$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "knocknock/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'knocknock'
  s.version     = Knocknock::VERSION
  s.authors     = ['Zaki Khan']
  s.email       = ['zakmysta@gmail.com']
  s.homepage    = 'https://github.com/zakmysta/knocknock'
  s.summary     = 'Seamless JWT authentication for Rails API.'
  s.description = 'Authentication solution for Rails based on JWT'
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '>= 5.0.0.beta1', '< 5.1'
  s.add_dependency 'jwt', '~> 1.5'
  s.add_dependency 'bcrypt', '~> 3.1'

  s.add_development_dependency 'sqlite3', '~> 1.3'
end
