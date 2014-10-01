# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/delayed_job/version'

Gem::Specification.new do |gem|
  gem.name          = "capistrano-delayed-job"
  gem.version       = Capistrano::DelayedJob::VERSION
  gem.authors       = ["Ruben Stranders"]
  gem.email         = ["r.stranders@gmail.com"]
  gem.description   = <<-EOF.gsub(/^\s+/, '')
    Capistrano tasks for automatic and sensible DelayedJob configuration.

    Enables zero downtime deployments of Rails applications. Configs can be
    copied to the application using generators and easily customized.

    Works *only* with Capistrano 3+.

    Inspired by https://github.com/bruno-/capistrano-unicorn-nginx and http://bl.ocks.org/dv/10370719
  EOF
  gem.summary       = "Capistrano tasks for automatic and sensible DelayedJob configuration."
  gem.homepage      = "https://github.com/capistrano-plugins/capistrano-delayed-job"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "capistrano", ">= 3.1"
  gem.add_dependency "sshkit", ">= 1.2.0"

  gem.add_dependency "daemons", ">= 1.1"

  gem.add_development_dependency "rake"
end
