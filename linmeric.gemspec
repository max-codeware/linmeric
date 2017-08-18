# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "linmeric/version"


Gem::Specification.new do |spec|
  spec.name          = "linmeric"
  spec.version       = Linmeric::VERSION
  spec.authors       = ["Massimiliano Dal Mas"]
  spec.email         = ["max.codeware@gmail.com"]

  spec.summary       = %q{Simple numeric calculator}
  spec.description   = %q{Simple command line calculator to make operations on matrices and functions}
  spec.homepage      = "https://max-codeware.github.io/linmeric/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["lib/**/*.rb","bin/*/**/*.rb","doc/**/**/*.*"]
  spec.extra_rdoc_files = ["README.md","Gemfile","Rakefile","LICENSE.txt"]
  spec.required_ruby_version = '>= 1.9.3'
  spec.bindir        = "bin"
  spec.executables   << "linmeric" << "linguide"
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
