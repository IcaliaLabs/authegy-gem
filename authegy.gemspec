# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'authegy/version'

# rubocop:disable Metrics/BlockLength
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
    '{app,config,lib}/**/*',
    'CHANGELOG.md',
    'LICENSE.md',
    'README.md'
  ]

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 5.2'

  spec.add_dependency 'devise', '~> 4.6', '>= 4.6.1'

  spec.add_development_dependency 'sqlite3', '~> 1.3.6'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-rails'
end
# rubocop:enable Metrics/BlockLength
