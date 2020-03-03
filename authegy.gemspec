# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'authegy/version'

# Describe your gem and declare its dependencies:
# rubocop:disable Metrics/BlockLengthq
Gem::Specification.new do |spec|
  spec.name          = 'authegy'
  spec.version       = Authegy::VERSION
  spec.authors       = ['Roberto Quintanilla']
  spec.email         = ['vov@icalialabs.com']

  spec.summary       = 'Opinionated app strategy used for authentication &' \
                       ' role-based authorization.'
  spec.description   = 'Opinionated app strategy used for authentication &' \
                       ' role-based authorization.'
  spec.homepage      = 'https://github.com/vovimayhem/authegy-gem'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/vovimayhem/authegy'
    spec.metadata['changelog_uri'] = spec.metadata['source_code_uri'] +
                                     '/blob/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir[
    '{lib}/**/*',
    'CHANGELOG.md',
    'LICENSE.md',
    'README.md'
  ]

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 5', '>= 5.2.3'
  spec.add_dependency 'devise', '~> 4.6', '>= 4.6.1'

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'shoulda-matchers'
end
# rubocop:enable Metrics/BlockLength
