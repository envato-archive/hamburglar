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

    it "sets @response" do
      @report.instance_variable_get(:@response).should be_a Hash
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
    before :each do
      Hamburglar.configure do |c|
        c.fraud_proc = Proc.new { |report| report.score < 5 }
      end
      @fraud = Hamburglar::Report.new
      @fraud.instance_variable_get(:@response)[:score] = 1
    end

    describe "calls Hamburglar.config.fraud_proc" do
      it "returns true" do
        @fraud.instance_variable_get(:@response)[:score] = 1
        @fraud.fraud?.should == true
      end

      it "returns false" do
        @fraud.instance_variable_get(:@response)[:score] = 10
        @fraud.fraud?.should == false
      end
    end
  end

  describe "#respond_to?" do
    it "returns true if @response[key] exists" do
      @report.should respond_to :missing_parameters
    end

    it "returns true if the method exists" do
      @report.should respond_to :inspect
    end

    it "returns false unless @response[key] and method exist" do
      @report.should_not respond_to :i_am_not_real
    end
  end

  describe "#method_missing" do
    it "returns @response[key] if it exists" do
      @report.missing_parameters.should_not be_nil
    end

    it "raises NoMethodError if @report[key] isn't found" do
      expect { @report.i_am_not_a_method! }.to raise_error NoMethodError
    end
  end

  describe "#response" do
    should_be_attr_reader :response, Hamburglar::Report.new
  end
end
