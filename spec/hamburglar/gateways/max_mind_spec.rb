require 'spec_helper'

describe Hamburglar::Gateways::MaxMind do
  describe "required parameters" do
    [:i, :city, :region, :postal, :country, :license_key].each do |p|
      it { Hamburglar::Gateways::MaxMind.required_params.should include p }
    end
  end

  describe "::api_url" do
    it "has a valid API URL" do
      Hamburglar::Gateways::MaxMind.api_url.should match /https?:\/\/[\S]+/
    end
  end
end
