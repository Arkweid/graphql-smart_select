# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql/smart_select/version'

Gem::Specification.new do |spec|
  spec.name          = 'graphql-smart_select'
  spec.version       = GraphQL::SmartSelect::VERSION
  spec.authors       = ['Alexander Abroskin']
  spec.email         = ['a.a.abroskin@yandex.ru']

  spec.summary       = 'Plugin for graphql-ruby gem'
  spec.description   = 'Provide logic for select only required fields from query'
  spec.homepage      = 'https://github.com/Arkweid/graphql-smart_select'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.3.0'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR).select { |p| p.match(%r{^lib/}) } +
                       %w[README.md CHANGELOG.md LICENSE.txt]

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'graphql', '~> 1.8.7'

  spec.add_development_dependency 'activerecord', '>= 4.2'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug', '~> 10.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'
  spec.add_development_dependency 'appraisal', '~> 2.2'
end
