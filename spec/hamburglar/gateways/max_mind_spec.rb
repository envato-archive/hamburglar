require 'spec_helper'

describe Hamburglar::Gateways::MaxMind do
  describe "::MinFraud" do
    before :each do
      @min_fraud = Hamburglar::Gateways::MaxMind::MinFraud.new
    end

    describe "#optional_params" do
      it { @min_fraud.optional_params.should be_an Array }
      it { @min_fraud.optional_params.should be_frozen }
    end

    describe "::required_params" do
      [:i, :city, :region, :postal, :country, :license_key].each do |p|
        it { @min_fraud.class.required_params.should include p }
      end
    end

    describe "::api_url" do
      reg = Hamburglar::Gateways::Base::URL_REGEX
      it { @min_fraud.class.api_url.should match reg }
    end
  end

  describe "::TelephoneVerification" do
    before :each do
      @phone = Hamburglar::Gateways::MaxMind::TelephoneVerification.new
    end

    describe "#optional_params" do
      it { @phone.optional_params.should be_an Array }
      it { @phone.optional_params.should be_frozen }
    end

    describe "::required_params" do
      [:l, :phone].each do |p|
        it { @phone.class.required_params.should include p }
      end
    end

    describe "::api_url" do
      reg = Hamburglar::Gateways::Base::URL_REGEX
      it { @phone.class.api_url.should match reg }
    end
  end
end
