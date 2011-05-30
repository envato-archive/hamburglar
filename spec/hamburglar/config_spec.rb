require 'spec_helper'

describe Hamburglar::Config do
  before :each do
    @config = Hamburglar::Config.new
  end

  describe "#initialize" do
    it "sets @gateway" do
      @config.instance_variable_get(:@gateway).should == :max_mind_min_fraud
    end

    it "sets @credentials" do
      @config.instance_variable_get(:@credentials).should be_a Hash
    end
  end

  %w[gateway credentials].each do |key|
    should_be_attr_accessor key.to_sym, Hamburglar::Config.new
  end
end
