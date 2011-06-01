require 'spec_helper'

describe Hamburglar::Config do
  before :each do
    @config = Hamburglar::Config.new
  end

  describe "#initialize" do
    it "sets @gateway" do
      @config.instance_variable_get(:@gateway).to_s.should match /min_fraud/
    end

    it "sets @credentials" do
      @config.instance_variable_get(:@credentials).should be_a Hash
    end
  end

  should_be_attr_accessor :credentials, Hamburglar::Config.new
  should_be_attr_reader :gateway, Hamburglar::Config.new

  describe "#gateway=" do
    it "sets the gateway" do
      @config.gateway = :max_mind_telephone
      @config.gateway.should == :max_mind_telephone
    end
  end
end
