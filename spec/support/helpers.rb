class CustomAuthenticatableTestClass
  include Devise::Models::CustomAuthenticatable

  def valid_for_custom_authentication?(*args); end
  def authenticated_by_test1_strategy?(*args); end
  def authenticated_by_test2_strategy?(*args); end
end

def env_with_params(path = "/", params = {}, env = {})
  method = params.delete(:method) || "GET"
  env = { 'HTTP_VERSION' => '1.1', 'REQUEST_METHOD' => "#{method}" }.merge(env)
  Rack::MockRequest.env_for("#{path}?#{Rack::Utils.build_query(params)}", env)
end
