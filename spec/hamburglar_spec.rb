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
    it "returns an array of registered gateways" do
      Hamburglar::GATEWAYS.should be_a Array
    end
  end

  describe "::gateway" do
    it "sets and gets the gateway" do
      Hamburglar.gateway = :foo
      Hamburglar.gateway.should == :foo
    end
  end
end
