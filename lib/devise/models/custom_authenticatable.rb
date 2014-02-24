require 'devise/strategies/custom_authenticatable'

module Devise::Models
  module CustomAuthenticatable
    extend ActiveSupport::Concern

    included do
      attr_accessor :password
    end

    def authenticated_by_any_custom_strategy?(password, *strategies)
      strategies.any? do |strategy|
        self.send(:"authenticated_by_#{strategy}_strategy?", password)
      end
    end

    def skip_custom_strategies
      throw :skip_custom_strategies
    end

  end
end
