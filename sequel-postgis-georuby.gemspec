Gem::Specification.new do |s|
  s.name        = 'sequel-postgis-georuby'
  s.version     = '0.1.2'
  s.date        = '2018-07-01'
  s.summary     = "Minimal gem for working with Postgis data in Sequel"
  s.description = "A gem to convert Postgis geometry columns to GeoRuby Simple Features in Sequel."
  s.authors     = ["Barry Sears"]
  s.email       = 'barry.sears@gmail.com'
  s.required_ruby_version = '~> 2.0'
  s.add_dependency 'sequel', '~> 5.0'
  s.add_dependency 'georuby', '~> 2.5.2'

  s.add_development_dependency 'rspec', '~> 3.0'

  s.files       = [ "lib/sequel-postgis-georuby.rb",
                    'lib/georuby/geometry_literal.rb',
                    "lib/sequel/extensions/postgis_georuby.rb"
                  ]
  s.homepage    =
    'http://rubygems.org/gems/sequel-postgis-georuby'
  s.license       = 'MIT'
end
