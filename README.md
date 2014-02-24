# DeviseCustomAuthenticatable

[![Build Status](https://travis-ci.org/AMekss/devise_custom_authenticatable.png?branch=master)](https://travis-ci.org/AMekss/devise_custom_authenticatable)
[![Gem Version](https://badge.fury.io/rb/devise_custom_authenticatable.png)](http://badge.fury.io/rb/devise_custom_authenticatable)

This gem is extension for [Devise](http://github.com/plataformatec/devise) authentication. It provides custom strategy via extended module `:custom_authenticatable` which is simple way how to customize Devise authentication logic but stay inline with all other features e.g. modules `:rememberable`, `:lockable`, `:timeoutable`, default controllers and even views if you like. `:custom_authenticatable` can work together with Devise default authentication strategy `:database_authenticatable` or on its own.

## Installation

Add this line to your application's Gemfile:

    gem 'devise_custom_authenticatable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise_custom_authenticatable

##Prerequisites

* devise >= 2.0

## Usage

[Devise](http://github.com/plataformatec/devise) should be already installed and enabled for any resource in your app. Open Devise enabled model and add `:custom_authenticatable`. When strategy is enabled it'll try to call `#valid_for_custom_authentication?` method on resource model with password. Define this method and return true in order to authenticate user or false in order to fail authentication. If there is no such method for model then authentication handling will be passed to next strategy e.g. `:database_authenticatable`, if there is no other strategies left for resource then authentication will be failed. For example:

```ruby
    devise :custom_authenticatable, :database_authenticatable, :trackable, :lockable, :timeoutable
    # OR
    devise :custom_authenticatable, :trackable, :lockable, :timeoutable

    # AND

    def valid_for_custom_authentication?(password)
      # Your authentication logic goes here and returns either true or false
      LDAP.authenticate(self.username, password)
    end
```

###This gem also provide few handy helpers

Use `#authenticated_by_any_custom_strategy?` when for example you would like to provide LDAP authentication for users, but also would like to have some dummy password in development environments. You can write something like this:

```ruby
    class User
      devise :custom_authenticatable, :trackable, :lockable, :timeoutable
      # ...

      def valid_for_custom_authentication?(password)
        authenticated_by_any_custom_strategy?(password, :development, :ldap)
      end

      def authenticated_by_development_strategy?(password)
        if %w{development test demo}.include?(Rails.env)
          password == 'dummy'
        end
      end

      def authenticated_by_ldap_strategy?(password)
        logger.info "  Authenticate user '#{self.user_name}' with Active Directory..."
        !!Ldap.authenticate(self.username, password)
      end
    end
```

It will call all `authenticated_by_<strategy_name>_strategy?(password)` in turn if any of strategy methods return true authentication succeed otherwise fail.

**Note!** If you are using development strategies in your app always cover it with unit tests so it never get used in production by mistake, something like this for rspec:

```ruby
    it "development strategy shouldn't be enabled for Production environment" do
      Rails.stub(env: ActiveSupport::StringInquirer.new("production"))
      expect(@user.authenticated_by_development_strategy?('dummy')).not_to be_true
    end
```

Use `#skip_custom_strategies` when you would like to conditionaly skip entire custom authentication, so for example in order to provide some custom care for admin users you could write something like this:

```ruby
    class User
      devise :custom_authenticatable, :trackable, :lockable, :timeoutable
      # ...

      def valid_for_custom_authentication?(password)
        if self.has_role?(:admin)
          # Your admin user authentication logic goes here and returns either true or false
        else
          skip_custom_strategies
        end
      end
    end
```

Use `#after_custom_authentication` in order to insert your own logic that is only run after the user successfully authenticates


## TODO

* Write Integration tests

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
