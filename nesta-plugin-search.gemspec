# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nesta-plugin-search/version"

Gem::Specification.new do |s|
  s.name        = "nesta-plugin-search"
  s.version     = Nesta::Plugin::Search::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joshua Mervine"]
  s.email       = ["joshua@mervine.net"]
  s.homepage    = "http://github.com/jmervine/search-plugin-nesta"
  s.summary     = %q{Search plugin for Nesta CMS}
  s.description = %q{Uses Ferret to search your Nesta site. Based on https://github.com/gma/nesta-search.}

  s.add_dependency 'ferret', '=0.11.8.5'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
