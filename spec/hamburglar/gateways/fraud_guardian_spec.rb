require 'spec_helper'

describe Hamburglar::Gateways::FraudGuardian do
  before :each do
    @fraud_guardian = Hamburglar::Gateways::FraudGuardian.new
  end

  describe "#optional_params" do
    it { @fraud_guardian.optional_params.should be_an Array }
    it { @fraud_guardian.optional_params.should be_frozen }
  end

  describe "::required_params" do
    [:i, :domain, :city, :region, :postal, :country, :login, :pass].each do |p|
      it { @fraud_guardian.class.required_params.should include p }
    end
  end

  describe "::api_url" do
    reg = Hamburglar::Gateways::Base::URL_REGEX
    it { @fraud_guardian.class.api_url.should match reg }
  end

  # TODO - remove this when we figure out the API url
  describe "#submit" do
    pending
  end
end
