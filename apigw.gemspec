# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apigw/version'

Gem::Specification.new do |spec|
  spec.name          = "apigw"
  spec.version       = ApiGW::VERSION
  spec.authors       = ["NTT Communications APIGateway Teams"]
  spec.email         = ["apigateway@ntt.com"]

  spec.summary       = %q{NTT Communications APIGateway SDK}
  spec.description   = %q{NTT Communications APIGateway SDK}
  spec.homepage      = "https://github.com/nttcom/apigw-ruby-sdk"

  spec.files = Dir["README.md", "lib/**/*.rb", "*.gemspec" ]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
end
