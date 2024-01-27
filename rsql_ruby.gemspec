# frozen_string_literal: true
require_relative 'lib/rsql_ruby/version'

Gem::Specification.new do |spec|
  spec.name    = 'rsql_ruby'
  spec.version = RsqlRuby::VERSION
  spec.authors = ['Dmitry Arkhipov']
  spec.email   = ['d.arkhipov@ekzo.dev']

  spec.summary     = 'RSQL parser for ruby'
  spec.description = 'Ruby RSQL/FIQL parser library'

  spec.homepage              = 'https://github.com/ekzobrain/rsql-ruby'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = 'https://github.com/ekzobrain/rsql-ruby/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'racc', '~> 1.7'
  spec.add_development_dependency 'oedipus_lex', '~> 2.6'
  spec.add_development_dependency 'minitest', '~> 5.21'
  spec.add_development_dependency 'rake', '~> 13.0'
end
