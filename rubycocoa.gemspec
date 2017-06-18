# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubycocoa/version"

Gem::Specification.new do |spec|
  spec.name          = "rubycocoa"
  spec.version       = Rubycocoa::VERSION
  spec.authors       = ["kimura wataru"]
  spec.email         = ["kimuraw@i.nifty.jp"]

  spec.summary       = "RubyCocoa - A Ruby/Objective-C Bridge"
  spec.description   = <<EOS
RubyCocoa is a framework for Mac OS X that allows Cocoa programming in 
the object-oriented scripting language Ruby.

RubyCocoa lets you write a Cocoa application in Ruby. It allows you to 
create and use a Cocoa object in a Ruby script. It's possible to write 
a Cocoa application that mixes Ruby and Objective-C code.
EOS
  spec.homepage      = "http://rubycocoa.github.io/"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/rubycocoa/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "minitest", "~> 5.0"
end
