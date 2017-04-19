Gem::Specification.new do |spec|
  spec.name           = "rodauth-become_account"
  spec.version        = "0.1.0"
  spec.authors        = ["Adam Daniels"]
  spec.email          = "adam@mediadrive.ca"

  spec.summary        = %q(Easily switch Rodauth accounts)
  spec.homepage       = "https://github.com/adam12/rodauth-become_account"
  spec.license        = "MIT"

  spec.files          = ["README.md"] + Dir["lib/**/*.rb"]
  spec.require_paths  = ["lib"]

  spec.add_dependency "rodauth", "~> 1.10"
  spec.add_development_dependency "roda", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubygems-tasks", "~> 0.2"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "tilt", "~> 2.0"
  spec.add_development_dependency "rack_csrf"
  spec.add_development_dependency "bcrypt"
  spec.add_development_dependency "sequel"
  spec.add_development_dependency "capybara"

  if RUBY_PLATFORM =~ /java/
    spec.add_development_dependency "jdbc-sqlite3"
  else
    spec.add_development_dependency "sqlite3"
  end
end
