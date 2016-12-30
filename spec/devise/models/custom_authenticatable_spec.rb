RSpec.describe Devise::Models::CustomAuthenticatable do
  subject(:resource) { CustomAuthenticatableTestClass.new }

  it "defines password attribute accessors" do
    resource.password = 'password'
    expect(resource.password).to eq 'password'
  end

  describe "#authenticated_by_any_custom_strategy? helper" do
    before(:each) do
      allow(resource).to receive(:authenticated_by_test1_strategy?).and_return(true)
      allow(resource).to receive(:authenticated_by_test2_strategy?).and_return(true)
    end

    context "should call all given strategy methods and" do
      it "returns false if all of them return false" do
        expect(resource).to receive(:authenticated_by_test1_strategy?).with('password').and_return(false)
        expect(resource).to receive(:authenticated_by_test2_strategy?).and_return(false)

        expect(resource.authenticated_by_any_custom_strategy?('password', :test1, :test2)).to be_falsey
      end

      it "returns true if any of them return true" do
        expect(resource).to receive(:authenticated_by_test1_strategy?).with('password').and_return(false)
        expect(resource).to receive(:authenticated_by_test2_strategy?).and_return(true)

        expect(resource.authenticated_by_any_custom_strategy?('password', :test1, :test2)).to be_truthy
      end

      it "returns true if all of them return true" do
        expect(resource.authenticated_by_any_custom_strategy?('password', :test1, :test2)).to be_truthy
      end
    end
  end
end
