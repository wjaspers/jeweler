# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'lib', 'jeweler', 'version')

Gem::Specification.new do |s|
  s.name        = 'jeweler'
  s.version     = Jeweler::VERSION
  s.license     = 'MIT'
  s.platform    = Gem::Platform::RUBY
  s.date        = '2018-09-01'
  s.summary     = ''
  s.description = ''
  s.authors     = ['Will Jaspers']
  s.email       = ''
  s.has_rdoc    = false
  s.homepage    = 'http://github.com/wjaspers/jeweler.git'

  s.add_development_dependency('minitest', '>= 5.8')
  s.add_development_dependency('minitest-reporters', '>= 1.1')
  s.add_development_dependency('rake', '>= 10.0')

  s.files         = Dir.glob('{lib}/**/*') + %w[jeweler.gemspec]
  s.require_paths = %w[lib]
end
