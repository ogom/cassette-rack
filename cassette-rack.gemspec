# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cassette-rack/version'

Gem::Specification.new do |spec|
  spec.name          = "cassette-rack"
  spec.version       = CassetteRack::VERSION
  spec.authors       = ["ogom"]
  spec.email         = ["takashi@bouquetec.com"]
  spec.summary       = %q{Operate of the VCR cassette}
  spec.description   = %q{Operate of the VCR cassette on Rack}
  spec.homepage      = "http://ogom.github.io/cassette-rack"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '~> 0.15'
  spec.add_dependency 'kramdown', '~> 2.1'
  spec.add_dependency 'liquid', '~> 4.0'
  spec.add_dependency 'rack', '~> 2.0'
  spec.add_dependency 'vcr', '~> 5.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
