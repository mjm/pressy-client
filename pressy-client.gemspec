
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pressy/client/version"

Gem::Specification.new do |spec|
  spec.name          = "pressy-client"
  spec.version       = Pressy::Client::VERSION
  spec.authors       = ["Matt Moriarity"]
  spec.email         = ["matt@mattmoriarity.com"]

  spec.summary       = %q{A simple library for interacting with Wordpress.}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "xmlrpc"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-mocks", "~> 3.0"
end
