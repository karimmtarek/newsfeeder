# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newsfeeder/version'

Gem::Specification.new do |spec|
  spec.name          = "newsfeeder"
  spec.version       = Newsfeeder::VERSION
  spec.authors       = ["karim Tarek"]
  spec.email         = ["karimmtarek@gmail.com"]

  spec.summary       = %q{Newsfeeder aggregates news data and publishes it to Redis.}
  spec.description   = %q{Newsfeeder downloads zip files from a remote HTTP folder, extract out the xml files, and publish the content of each xml file to a redis list.}
  spec.homepage      = "https://github.com/karimmtarek/newsfeeder"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency 'mechanize'
  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'rubyzip'
  spec.add_runtime_dependency 'redis'
  spec.add_runtime_dependency 'progress_bar'
end
