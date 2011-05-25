require 'spec_helper'

describe Hamburglar::Gateways::MaxMind do
  describe "::api_url" do
    it "has a valid API URL" do
      Hamburglar::Gateways::MaxMind.api_url.should match /https?:\/\/[\S]+/
    end
  end
end
