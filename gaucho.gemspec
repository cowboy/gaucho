# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gaucho/version"

Gem::Specification.new do |s|
  s.name        = "gaucho"
  s.version     = Gaucho::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['"Cowboy" Ben Alman']
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "gaucho"

  s.add_dependency "grit", "~> 2.4"

  s.add_development_dependency "rspec", "~> 2.6"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
