# DeviseCustomAuthenticatable

Simple way how to customize devise authentication logic and still be inline with all other devise parts

Extends Devise with new module `:custom_authenticatable`, when used it will call `#valid_for_model_authentication?` method on resource model with password if such defined. Return true in order to authenticate user. If method isn't defined for model or return false/nil then authentication handling will be passed to next strategy e.g. `:database_authenticatable`, if there is no other strategies for resource left then authentication will be failed.

## Installation

Add this line to your application's Gemfile:

    gem 'devise_custom_authenticatable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise_custom_authenticatable

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
