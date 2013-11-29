# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ototwe/version'

Gem::Specification.new do |spec|
  spec.name          = "ototwe"
  spec.version       = Ototwe::VERSION
  spec.authors       = ["kyoendo"]
  spec.email         = ["postagie@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"
  spec.add_dependency "haml"
  spec.add_dependency "puma"
  spec.add_dependency "eventmachine"
  spec.add_dependency "em-http-request"
  spec.add_dependency "faye-websocket"
  spec.add_dependency "simple_oauth"
  spec.add_dependency "yajl-ruby"
  spec.add_dependency "json"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "foreman"
end
