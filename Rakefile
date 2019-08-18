$LOAD_PATH.unshift File.expand_path('./lib', __dir__)

require 'rspec/core/rake_task'
require 'authegy/version'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Build authegy-#{Authegy::VERSION}.gem"
task :build do
  system 'gem build authegy.gemspec'
end

desc "Build and push authegy-#{Authegy::VERSION}.gem"
task release: :build do
  system "gem push authegy-#{Authegy::VERSION}.gem"
end
