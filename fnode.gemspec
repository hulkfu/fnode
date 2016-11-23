# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'fnode/version'

Gem::Specification.new do |s|
  s.name        = 'fnode'
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
  s.bindir   = %w(exe)
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.homepage    = 'https://bitbucket.org/phun/fnode'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end


  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'logging'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'
end
