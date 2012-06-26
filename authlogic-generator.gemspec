require File.expand_path("../lib/authlogic/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "authlogic-generator"
  s.version     = AuthlogicGenerator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Larry Scott"]
  s.email       = ["lscott3@gmail.com"]
  s.homepage    = "http://github.com/lscott3/authlogic-generator"
  s.summary     = "Generates basic authentication functionality for authlogic"
  s.description = "This gem generates the controllers, models, migration file(s), and views needed for basic authentication with authlogic. This will also write routes for login, logout, signup and forgot password."

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "authlogic-generator"

  # If you have other dependencies, add them here
  s.add_development_dependency "rails", "~> 3.2.6"
  

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  # s.executables = ["newgem"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end