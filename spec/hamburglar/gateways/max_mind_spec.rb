require 'spec_helper'

describe Hamburglar::Gateways::MaxMind do
  describe "::required_parameters" do
    [:i, :city, :region, :postal, :country, :license_key].each do |p|
      it { Hamburglar::Gateways::MaxMind.required_params.should include p }
    end
  end

  describe "::optional_parameters" do
    [
      :domain, :bin, :binName, :binPhone, :custPhone, :requested_type,
      :forwardedIP, :emailMD5, :usernameMD5, :passwordMD5, :shipAddr,
      :shipCity, :shipRegion, :shipPostal, :shipCountry, :textID, :sessionID,
      :user_agent, :accept_language
    ].each do |p|
      it { Hamburglar::Gateways::MaxMind.optional_params.should include p }
    end
  end

  describe "::api_url" do
    it "has a valid API URL" do
      Hamburglar::Gateways::MaxMind.api_url.should match /https?:\/\/[\S]+/
    end
  end
end
