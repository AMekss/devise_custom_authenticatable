require 'spec_helper'

describe Devise::Models::CustomAuthenticatable do
  before(:each) do
    @resource = CustomAuthenticatableTestClass.new
    @it = Devise::Strategies::CustomAuthenticatable.new(env_with_params, :user)
  end

  describe "#authenticate!" do
    before(:each) do
      password_hash = { password: 'password' }
      @it.stub( password_hash )
      @it.stub(authentication_hash: password_hash)
      @it.stub_chain(:mapping, :to, :find_for_authentication).and_return(@resource)
      @it.stub(:validate) do |resource, &block|
        expect(resource).to eq @resource
        block.call
      end
    end

    it "should pass to another strategy if #valid_for_custom_authentication? is not defined" do
      expect(@it).to receive(:validate).never
      expect(@it).to receive(:pass).once.and_return('skip')
      expect(@it.authenticate!).to eq 'skip'
    end

    it "should pass to another strategy if #valid_for_custom_authentication? is defined but return false" do
      expect(@resource).to receive(:valid_for_custom_authentication?).with('password').and_return(false)
      expect(@it).to receive(:validate).once
      expect(@it).to receive(:pass).once.and_return('skip')
      expect(@it.authenticate!).to eq 'skip'
    end

    it "should return with success! if #valid_for_custom_authentication? is defined and return true" do
      expect(@resource).to receive(:valid_for_custom_authentication?).with('password').and_return(true)
      expect(@it).to receive(:pass).never
      expect(@it).to receive(:validate).once
      expect(@it).to receive(:success!).once.with(@resource).and_return('success')
      expect(@it.authenticate!).to eq 'success'
    end
  end

  describe "#validate" do
    before(:each) do
      @block = -> { }
    end

    it "should return false if resource is nil" do
      expect(@it).to receive(:decorate).never
      expect(@it.validate(nil, &@block)).to be_false
    end

    it "should return false if valid_for_authentication? on resource return false" do
      expect(@resource).to receive(:valid_for_authentication?).with(&@block).and_return(false)
      expect(@it).to receive(:decorate).never
      expect(@it.validate(@resource, &@block)).to be_false
    end

    it "should return true and decorate resource if valid_for_authentication? on resource return true" do
      expect(@resource).to receive(:valid_for_authentication?).with(&@block).and_return(true)
      expect(@it).to receive(:decorate).with(@resource)
      expect(@it.validate(@resource, &@block)).to be_true
    end
  end

end
