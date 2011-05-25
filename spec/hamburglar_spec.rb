require 'spec_helper'

describe Hamburglar do
  describe "::Version" do
    it "has a valid version" do
      Hamburglar::Version.should match /\d+\.\d+\.\d+/
    end
  end

  describe "::credentials" do
    it "sets and gets the credentials" do
      Hamburglar.credentials = { :foo => 'foo' }
      Hamburglar.credentials.should be_a Hash
      Hamburglar.credentials.should have_key :foo
    end
  end

  describe "::GATEWAYS" do
    it { Hamburglar::GATEWAYS.should be_a Array }
    it { Hamburglar::GATEWAYS.should be_frozen  }
  end

  describe "::gateway" do
    it "sets and gets the gateway" do
      Hamburglar.gateway = :max_mind
      Hamburglar.gateway.should == :max_mind
    end
  end
end
