require 'spec_helper'

describe Devise::Models::CustomAuthenticatable do
  before(:each) do
    @it = CustomAuthenticatableTestClass.new
  end

  it "password attribute accessors should be defined" do
    @it.password = 'password'
    expect(@it.password).to eq 'password'
  end

  describe "#authenticated_by_any_custom_strategy? helper" do
    before(:each) do
      @it.stub(authenticated_by_test1_strategy?: true)
      @it.stub(authenticated_by_test2_strategy?: true)
    end

    context "should call all given strategy methods and" do
      it "return false if all of them return false" do
        expect(@it).to receive(:authenticated_by_test1_strategy?).with('password').and_return(false)
        expect(@it).to receive(:authenticated_by_test2_strategy?).and_return(false)

        expect(@it.authenticated_by_any_custom_strategy?('password', :test1, :test2)).to be_false
      end

      it "return true if any of them return true" do
        expect(@it).to receive(:authenticated_by_test1_strategy?).with('password').and_return(false)
        expect(@it).to receive(:authenticated_by_test2_strategy?).and_return(true)

        expect(@it.authenticated_by_any_custom_strategy?('password', :test1, :test2)).to be_true
      end

      it "return true if all of them return true" do
        expect(@it.authenticated_by_any_custom_strategy?('password', :test1, :test2)).to be_true
      end
    end
  end

end
