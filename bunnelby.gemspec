# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunnelby/version'

Gem::Specification.new do |spec|
  spec.name          = "bunnelby"
  spec.version       = Bunnelby::VERSION
  spec.authors       = ["Hubert Łępicki"]
  spec.email         = ["hubert.lepicki@amberbit.com"]

  spec.summary       = %q{Bunnelby provides simple abstractions for RPC with RabbitMQ}
  spec.description   = %q{Base classes you can choose to build your RPC clients and servers with}
  spec.homepage      = "https://github.com/amberbit/bunnelby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
