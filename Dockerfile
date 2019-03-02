# I: Development Stage: ========================================================
# This is the initial stage where we build the development base image, which is
# used to work locally with the library code:

# Step 1: Use the official Ruby 2.6 Alpine image as base:
FROM ruby:2.6.1-alpine AS development

# Step 2: We'll set '/usr/src' path as the working directory:
WORKDIR /usr/src

# Step 3: We'll set the working dir as HOME and add the app's binaries path to
# $PATH:
ENV HOME=/usr/src PATH=/usr/src/bin:$PATH

# Step 4: Install the common runtime & development dependencies:
RUN apk add --no-cache \
  build-base \
  ca-certificates \
  chromium \
  chromium-chromedriver \
  git \
  less \
  nodejs \
  npm \
  openssl \
  sqlite-dev \
  su-exec \
  tzdata \
  yarn

# Step 5: Fix npm uid-number error
# - see https://github.com/npm/uid-number/issues/7
RUN npm config set unsafe-perm true

# Step 6: Install the 'check-dependencies' node package:
RUN npm install -g check-dependencies

# Step 7: Copy the project's Gemfile + lock:
ADD authegy.gemspec Gemfile* /usr/src/
ADD lib/authegy/version.rb /usr/src/lib/authegy/

# Step 8: Install the current project gems - they can be safely changed later
# during development via `bundle install` or `bundle update`:
RUN bundle install --jobs=4 --retry=3

# Step 9-11: Setup the development User
ARG DEVELOPER_UID="1000"
ARG DEVELOPER_USER="you"

RUN adduser -H -D -h /usr/src -u $DEVELOPER_UID $DEVELOPER_USER \
 && addgroup $DEVELOPER_USER root

# Step 12: Make the developer user name available as an environment variable:
ENV DEVELOPER_USER=$DEVELOPER_USER

# Step 13: Set the default command:
CMD [ "bundle", "console" ]

# II: Dummy Stage: =============================================================
# This stage will be used for the dummy app container, and it's only difference
# from the Development stage will be the dummy's bin directory will be prepended
# to $PATH, so executables on the dummy app will take precedence over the
# executables of the library:

# Step 14: Start off from the development stage image:
FROM development AS dummy

# Step 15: Prepend the dummy's bin directory to $PATH:
ENV PATH=/usr/src/spec/dummy/bin:$PATH

# III: Testing stage: ==========================================================
# In this stage we'll add the current code from the project's source, so we can
# run tests with the code.

# Step 14: Start off from the development stage image:
FROM development AS testing

# Step 15: Copy the rest of the application code
ADD . /usr/src

# Step 16: Install Yarn packages:
RUN yarn install
