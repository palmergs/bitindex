# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'bitindex/version'

Gem::Specification.new do |s|
  s.name        = 'bitindex'
  s.version     = Bitindex::VERSION
  s.authors     = ['Galen Palmer']
  s.email       = ['palmergs@gmail.com']
  s.homepage    = 'https://github.com/palmergs/bitindex'
  s.summary     = %q{Build a file where, given an integer value, the bit at that position indicates true or false.}
  s.description = %q{This library contains a Writer and Reader interface to create files where the position of a bit within the file indicates a true or false value.}

  s.rubyforge_project = 'bitindex'

  s.files         = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*']
  s.test_files    = Dir['{spec}/**/*']
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec', '~> 2.10'
end
