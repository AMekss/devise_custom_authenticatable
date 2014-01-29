require 'devise/strategies/authenticatable'

module Devise::Strategies
  # Strategy for delegateing authentication logic to custom model's method
  class CustomAuthenticatable < Authenticatable

    def authenticate!
      resource  = valid_password? && mapping.to.find_for_authentication(authentication_hash)
      return pass unless resource.respond_to?(:valid_for_custom_authentication?)

      if validate(resource){ resource.valid_for_custom_authentication?(password) }
        success!(resource)
      else
        pass
      end
    end

    # Override default Devise::Strategies::Authenticatable#validate method in order to *not* return fail! on flase,
    # but pass handling to other strategies in stack, e.g default :database_authenticatable or other similar
    # authentication will be failed with default message anyway if there are no strategies left
    def validate(resource, &block)
      if resource && resource.valid_for_authentication?(&block)
        decorate(resource)
        true
      else
        false
      end
    end

  end
end

Warden::Strategies.add(:custom_authenticatable, Devise::Strategies::CustomAuthenticatable)
