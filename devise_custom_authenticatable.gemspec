# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_custom_authenticatable/version'

Gem::Specification.new do |spec|
  spec.name          = "devise_custom_authenticatable"
  spec.version       = DeviseCustomAuthenticatable::VERSION
  spec.authors       = ["Artūrs Mekšs"]
  spec.email         = ["arturs.mekss@gmail.com"]
  spec.description   = %q{Simple way to customize devise authentication logic and still be inline with all other devise parts}
  spec.summary       = %q{Extends Devise with new module :custom_authenticatable, when enabled it will call #valid_for_custom_authentication? method on resource model for your customizations}
  spec.homepage      = "https://github.com/AMekss/devise_custom_authenticatable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"


  if defined?(RUBY_VERSION) && RUBY_VERSION >= "2.1" || defined?(JRUBY_VERSION) && JRUBY_VERSION >= "9000"
    spec.add_development_dependency "activemodel", ">= 3.1"

    spec.add_dependency "devise", ">= 2", "< 5"
  else
    spec.add_development_dependency "activemodel", "< 5"
    spec.add_development_dependency "activesupport", "< 5"
    spec.add_development_dependency "rack", "~> 1.6.4"

    spec.add_dependency "devise", ">= 2", "< 4"
  end
end
