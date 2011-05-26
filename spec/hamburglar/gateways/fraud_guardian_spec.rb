require 'spec_helper'

describe Hamburglar::Gateways::FraudGuardian do
  describe "::PARAMS" do
    it { Hamburglar::Gateways::FraudGuardian::PARAMS.should be_an Array }
    it { Hamburglar::Gateways::FraudGuardian::PARAMS.should be_frozen }
  end

  describe "::required_params" do
    [:i, :domain, :city, :region, :postal, :country, :login, :pass].each do |p|
      it { Hamburglar::Gateways::FraudGuardian.required_params.should include p }
    end
  end

  # TODO
  # Find out how Parallels distributes the API url, it may need to be a
  # value people can set themselves.
  describe "::api_url" do
    pending do
      reg = Hamburglar::Gateways::Base::URL_REGEX
      it { Hamburglar::Gateways::FraudGuardian.api_url.should match reg }
    end
  end

  # TODO - remove this when we figure out the API url
  describe "#initialize" do
    it do
      expect { Hamburglar::Gateways::FraudGuardian.new }.should raise_error /not implemented/
    end
  end
end
