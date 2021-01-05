# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq_retry_monitor/version'

Gem::Specification.new do |spec|
  spec.name = 'sidekiq_retry_monitor'
  spec.summary = 'Middleware for Sidekiq that reports to Rollbar if a job has retried a certain number of times'
  spec.homepage = 'https://github.com/charitywater/sidekiq_retry_monitor'
  spec.version = SidekiqRetryMonitor::VERSION
  spec.licenses = 'MIT'
  spec.authors = [
    'David Flaherty',
    'Tristan O\'Neil'
  ]

  spec.email = [
    'david.flaherty@charitywater.org',
    'tristan.oneil@charitywater.org'
  ]

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'rollbar'
end
