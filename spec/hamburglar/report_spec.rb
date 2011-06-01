require 'spec_helper'

describe Hamburglar::Report do
  before :each do
    @report = Hamburglar::Report.new(:foo => :bar)
  end

  describe "#initialize" do
    it "sets @params" do
      p = @report.instance_variable_get(:@params)
      p.should be_a Hash
      p.should have_key :foo
    end

    it "sets @report" do
      @report.instance_variable_get(:@report).should be_a Hash
    end
  end

  describe "#params" do
    it "returns @params hash" do
      @report.params.should be_a Hash
      raw_params = @report.instance_variable_get(:@params)
      raw_params.should == @report.params
    end
  end

  describe "#gateway (private)" do
    it "returns the current gateway" do
      @report.instance_eval('gateway').should ==
        Hamburglar::Gateways::MaxMind::MinFraud

      @report.instance_variable_set(:@gateway, :max_mind_telephone)

      @report.instance_eval('gateway').should ==
        Hamburglar::Gateways::MaxMind::TelephoneVerification
    end

    it "raises InvalidGateway" do
      expect do
        @report.instance_variable_set(:@gateway, :foobar)
        @report.instance_eval('gateway')
      end.to raise_error Hamburglar::InvalidGateway
    end
  end

  describe "#generate_report! (private)" do
    before :each do
      @raw = @report.instance_eval('generate_report!')
    end
    it { @raw.should be_a Hash }
  end

  describe "#fraud?" do
    it "returns true or false"
  end

  describe "#respond_to?" do
    it "returns true if @report[key] exists" do
      @report.should respond_to :missing_parameters
    end

    it "returns true if the method exists" do
      @report.should respond_to :inspect
    end

    it "returns false unless @report[key] and method exist" do
      @report.should_not respond_to :i_am_not_real
    end
  end

  describe "#method_missing" do
    it "returns @report[key] if it exists" do
      @report.missing_parameters.should_not be_nil
    end

    it "raises NoMethodError if @report[key] isn't found" do
      expect { @report.i_am_not_a_method! }.to raise_error NoMethodError
    end
  end
end
