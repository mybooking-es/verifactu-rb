# frozen_string_literal: true

require_relative "lib/verifactu/version"

Gem::Specification.new do |spec|
  spec.name = "verifactu-rb"
  spec.version = Verifactu::VERSION
  spec.authors = ["Mybooking"]
  spec.email = ["info@mybooking.es"]

  spec.summary = "Verifactu Ruby Gem"
  spec.description = "Verifactu ruby Gem"
  spec.homepage = "https://mybooking.es"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "nokogiri", "1.17.2"
  spec.add_dependency "bigdecimal"
  spec.add_dependency "savon"
  spec.add_dependency "rack", "~> 2.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
