require 'spec_helper'

describe Hamburglar::Gateways::Base do
  before :each do
    Hamburglar.gateway = :max_mind
    @gateway = Hamburglar::Gateways::Base.new(:foo => :bar)
  end

  %w[required optional].each do |p|
    describe "::#{p}_params" do
      it "returns @#{p}_params without arguments" do
        Hamburglar::Gateways::Base.send("#{p}_params").should == []
      end

      it "sets @#{p}_params with arguments" do
        Hamburglar::Gateways::Base.send("#{p}_params", :one, :two, :three)
        Hamburglar::Gateways::Base.instance_variable_get("@#{p}_params").should ==
          [:one, :two, :three]
      end
    end
  end

  describe "::api_url" do
    it "gets and sets @api_url with an argument" do
      Hamburglar::Gateways::Base.api_url "http://example.com"
      Hamburglar::Gateways::Base.api_url.should == "http://example.com"
    end

    it "raises InvalidURL when setting an invalid URL" do
      expect {
        Hamburglar::Gateways::MaxMind.api_url "i'm not a url!"
      }.to raise_error(Hamburglar::InvalidURL)
    end
  end

  describe "#initialize" do
    it "sets @params" do
      p = @gateway.instance_variable_get(:@params)
      p.should be_a Hash
      p.should have_key :foo
    end

    it "sets @errors to a blank hash" do
      @gateway.instance_variable_get(:@errors).should == {}
    end
  end

  %w[params errors].each do |attr|
    describe "##{attr}" do
      it "returns @#{attr} hash" do
        val = @gateway.send(attr)
        raw = @gateway.instance_variable_get("@#{attr}")
        val.should be_a Hash
        val.should == raw
      end
    end
  end

  describe "#validate!" do
    it "returns false if required_params aren't set" do
      Hamburglar::Gateways::Base.required_params :one, :two
      @gateway.validate!.should == false
    end

    it "returns true if required_params are set" do
      Hamburglar::Gateways::Base.required_params :foo
      @gateway.validate!.should == true
    end

    it "adds missing params to @errors[:missing_parameters]" do
      Hamburglar::Gateways::Base.required_params :one, :two
      @gateway.validate!
      missing = @gateway.errors[:missing_parameters]
      missing.should be_an Array
      missing.should have(2).items
    end
  end

  describe "#submit!" do
    it "raises InvalidGateway unless Hamburglar.gateway is set" do
      Hamburglar.instance_variable_set(:@gateway, nil)
      expect do
        Hamburglar::Gateways::Base.new.submit!
      end.to raise_error Hamburglar::InvalidGateway
    end

    it "returns false if required_params aren't set" do
      Hamburglar::Gateways::Base.new.submit!.should == false
    end
  end
end
