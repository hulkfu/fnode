# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'fnode/version'

Gem::Specification.new do |s|
  s.name        = 'FNode'
  s.version     = FNode::VERSION
  s.licenses    = ['MIT']
  s.date        = '2016-08-29'
  s.summary     = "F Node."
  s.description = "F Node."
  s.authors     = ["Aston Fu"]
  s.email       = 'fudhao@gmail.com'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
  s.executables   = %w(fnode)
  s.homepage    = 'https://github.com/astonfu/fnode'

  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'logging'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'
end
