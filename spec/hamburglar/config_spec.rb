require 'spec_helper'

describe Hamburglar::Config do
  before :each do
    @config = Hamburglar::Config.new
    subject { @config }
  end

  describe "#initialize" do
    it "sets @gateway" do
      @config.instance_variable_get(:@gateway).to_s.should match /min_fraud/
    end

    it "sets @credentials" do
      @config.instance_variable_get(:@credentials).should be_a Hash
    end

    it "sets @fraud_score" do
      @config.instance_variable_get(:@fraud_score).should == 2.5
    end
  end

  it { should have_attr_accessor :fraud_score }
  it { should have_attr_accessor :fraud_proc  }
  it { should have_attr_accessor :credentials }
  it { should have_attr_reader   :gateway     }

  describe "#gateway=" do
    it "sets the gateway" do
      @config.gateway = :max_mind_telephone
      @config.gateway.should == :max_mind_telephone
    end
  end
end
