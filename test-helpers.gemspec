Gem::Specification.new do |s|
  s.name = 'test-helpers'
  s.version = '0.0.6'
  s.date = '2015-08-25'
  s.summary = "Test helpers!"
  s.description = "A collection of helpers."
  s.authors = ["Umair Chagani"]
  s.email = 'umair.chagani@manheim.com'
  s.files = ["lib/test-helpers.rb"]
  s.add_development_dependency 'rspec', '>= 2'
  s.add_development_dependency 'pry', '~> 0'
  s.homepage = 'http://github.com/manheim/test-helpers'
  s.license = 'MIT'
end
