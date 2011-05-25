require 'spec_helper'

describe Hamburglar::Report do
  before :each do
    Hamburglar.gateway = :max_mind
    @report = Hamburglar::Report.new(:foo => :bar)
  end

  describe "::required_params" do
    it "returns @required_params without arguments" do
      Hamburglar::Report.required_params.should == []
    end

    it "sets @required_params with arguments" do
      Hamburglar::Report.required_params :one, :two, :three
      Hamburglar::Report.instance_variable_get(:@required_params).should ==
        [:one, :two, :three]
    end
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

  describe "#validate!" do
    it "returns false if required_params aren't set" do
      Hamburglar::Report.required_params :one, :two
      @report.validate!.should == false
    end

    it "returns true if required_parames are set" do
      Hamburglar::Report.required_params :foo
      @report.validate!.should == true
    end
  end

  describe "#fraud?" do
    it "returns true or false"
  end

  describe "#submit!" do
    it "raises InvalidGateway unless Hamburglar.gateway is set" do
      expect do
        Hamburglar.gateway = nil
        Hamburglar::Report.new.submit!
      end.to raise_error Hamburglar::InvalidGateway
    end

    it "returns false if required_params aren't set" do
      Hamburglar::Report.new.submit!.should == false
    end
  end
end
