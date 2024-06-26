# frozen_string_literal: true

require_relative "lib/client/version"

Gem::Specification.new do |spec|
  spec.name        = "client" # referring to recommendations for naming gems https://guides.rubygems.org/name-your-gem/
  spec.version     = Client::VERSION
  spec.licenses    = ['MIT']
  spec.authors     = ["Cirro.io team"]
  spec.email       = [""]
  spec.summary     = "Helps you to connect your application to localize-docs.cirro.io easily"
  spec.description = "Helps you to connect your application to localize-docs.cirro.io easily"
  spec.homepage    = "https://github.com/test-IO/localize-ruby-client"

  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/test-IO/localize-ruby-client"
  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # register a new dependency of your gem
  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "jwt", "~> 2.8", ">= 2.8.1"
  spec.add_dependency "openssl", "~> 3.1"
  spec.add_dependency "httparty", "~> 0.21.0"
  spec.add_dependency "rubyzip", "~> 2.3"
  spec.add_dependency "activesupport", "~> 7.1.2"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "dotenv-rails", "~> 3.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
