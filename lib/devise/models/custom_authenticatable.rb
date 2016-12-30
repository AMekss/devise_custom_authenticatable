require 'devise/strategies/custom_authenticatable'

module Devise::Models
  module CustomAuthenticatable
    extend ActiveSupport::Concern

    included do
      attr_reader :password
    end

    def password=(password)
      @password = password
      super if defined?(super)
    end

    def authenticated_by_any_custom_strategy?(password, *strategies)
      strategies.any? do |strategy|
        self.send(:"authenticated_by_#{strategy}_strategy?", password)
      end
    end

    def skip_custom_strategies
      throw :skip_custom_strategies
    end

    # A callback initiated after successfully authenticating. This can be
    # used to insert your own logic that is only run after the user successfully
    # authenticates.
    def after_custom_authentication; end
  end
end
