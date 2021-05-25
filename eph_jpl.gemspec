# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eph_jpl/version'

Gem::Specification.new do |spec|
  spec.name          = "eph_jpl"
  spec.version       = EphJpl::VERSION
  spec.authors       = ["komasaru"]
  spec.email         = ["masaru@mk-mode.com"]

  spec.summary       = %q{Ephemeris calculation tool by JPL method.}
  spec.description   = %q{EphJcg is a ephemeris calculation tool by JPL method.}
  spec.homepage      = "https://github.com/komasaru/eph_jpl"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "bundler", ">= 2.2.10"
  #spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
