class CustomAuthenticatableTestClass
  include Devise::Models::CustomAuthenticatable

  def valid_for_custom_authentication?(*args); end
  def authenticated_by_test1_strategy?(*args); end
  def authenticated_by_test2_strategy?(*args); end
end

module TestPasswordModule
  extend ActiveSupport::Concern

  included do
    attr_accessor :encrypted_password
  end

  def password=(new_password)
    @password = new_password
    self.encrypted_password = "#{new_password}_encrypted" if @password.present?
  end
end

class CustomAuthenticatableTestClassWithPasswordWriter
  include TestPasswordModule
  include Devise::Models::CustomAuthenticatable
end

def env_with_params(path = "/", params = {}, env = {})
  method = params.delete(:method) || "GET"
  env = { 'HTTP_VERSION' => '1.1', 'REQUEST_METHOD' => "#{method}" }.merge(env)
  Rack::MockRequest.env_for("#{path}?#{Rack::Utils.build_query(params)}", env)
end
