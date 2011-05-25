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
  end

  describe "#params" do
    it "returns @params hash" do
      @report.params.should be_a Hash
      raw_params = @report.instance_variable_get(:@params)
      raw_params.should == @report.params
    end
  end

  describe "#fraud?" do
    it "returns true or false"
  end

  describe "#commit!" do
    it "raises InvalidGateway unless Hamburglar.gateway is set"
  end
end
