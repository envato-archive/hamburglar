require 'spec_helper'

describe Hamburglar::Gateways::MaxMind do
  describe "::MinFraud" do
    describe "::PARAMS" do
      it { Hamburglar::Gateways::MaxMind::MinFraud::PARAMS.should be_an Array }
      it { Hamburglar::Gateways::MaxMind::MinFraud::PARAMS.should be_frozen }
    end

    describe "::required_params" do
      [:i, :city, :region, :postal, :country, :license_key].each do |p|
        it { Hamburglar::Gateways::MaxMind::MinFraud.required_params.should include p }
      end
    end

    describe "::api_url" do
      reg = Hamburglar::Gateways::Base::URL_REGEX
      it { Hamburglar::Gateways::MaxMind::MinFraud.api_url.should match reg }
    end
  end

  describe "::TelephoneVerification" do
    it "has specs"
  end
end
