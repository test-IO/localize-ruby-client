# frozen_string_literal: true

require_relative "lib/client/version"

Gem::Specification.new do |spec|
  spec.name        = "localize_ruby_client"
  spec.version     = Client::VERSION
  spec.licenses    = ["MIT"]
  spec.authors     = ["Cirro.io team"]
  spec.email       = [""]
  spec.summary     = "Helps you to connect your application to localize-docs.cirro.io easily"
  spec.description = "Helps you to connect your application to localize-docs.cirro.io easily"
  spec.homepage    = "https://github.com/test-IO/localize-ruby-client"

  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/test-IO/localize-ruby-client"
  spec.metadata["changelog_uri"] = "https://github.com/test-IO/localize-ruby-client/blob/main/CHANGELOG.md"

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

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "httparty", "~> 0.21.0"
  spec.add_runtime_dependency "jwt"
  spec.add_runtime_dependency "multipart-post"
  spec.add_runtime_dependency "rake", "~> 13.0"
  spec.add_runtime_dependency "rubyzip", "~> 2.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
