lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'test-helpers/version.rb'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 2.3.0'
  s.name = 'test-helpers'
  s.version = TestHelpers::VERSION
  s.date = '2015-08-25'
  s.summary = "Test helpers!"
  s.description = "A collection of helpers."
  s.authors = ["Umair Chagani, Manheim"]
  s.email = 'umair.chagani@manheim.com, cloudops@manheim.com'
  s.files = Dir["lib/**/*"]
  s.require_path = 'lib'
  s.add_development_dependency 'rspec', '>= 2'
  s.add_development_dependency 'pry', '~> 0'
  s.homepage = 'http://github.com/manheim/test-helpers'
  s.license = 'MIT'
end
