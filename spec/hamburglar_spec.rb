require 'spec_helper'

describe Hamburglar do
  describe "::Version" do
    it "has a valid version" do
      Hamburglar::Version.should match /\d+\.\d+\.\d+/
    end
  end

  describe "::GATEWAYS" do
    it { Hamburglar::GATEWAYS.should be_a Array }
    it { Hamburglar::GATEWAYS.should be_frozen  }
  end

  describe "::configure" do
    it { Hamburglar.configure.should be_a Hamburglar::Config }
  end

  describe "::config" do
    should_be_attr_accessor :config, Hamburglar, Hamburglar::Config.new
  end

end
