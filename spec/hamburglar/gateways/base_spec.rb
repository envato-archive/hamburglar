require 'spec_helper'

describe Hamburglar::Gateways::Base do
  before :each do
    Hamburglar::Gateways::Base.set_required_params :license_key
    @gateway = Hamburglar::Gateways::Base.new(:foo => :bar)
    @gateway.class.set_api_url "http://example.com"
  end

  describe "::URL_REGEX" do
    reg = Hamburglar::Gateways::Base::URL_REGEX
    it { reg.should be_a Regexp }

    it "should match http urls" do
      "http://example.com/some/url.ext?p=f&amp;a=b".should match reg
    end

    it "should match https urls" do
      "https://example.com/some/url.ext?p=f&amp;a=b".should match reg
    end

    it "should not match non-urls" do
      ['i am not a url', 'ftp://example.com', 'git://example.com', 'http://', 'https://'].each do |url|
        url.should_not match reg
      end
    end
  end

  describe "::required_params" do
    it "returns @required_params" do
      should_require_params :one, :two, :three
    end
  end

  describe "::api_url" do
    it "gets @api_url" do
      @gateway.class.api_url.should == "http://example.com"
    end
  end

  describe "::set_api_url=" do
    it "sets @api_url" do
      @gateway.class.set_api_url "http://example2.com"
      @gateway.class.api_url.should == "http://example2.com"
    end

    it "raises InvalidURL when setting an invalid URL" do
      expect {
        @gateway.class.set_api_url "i'm not a url!"
      }.to raise_error(Hamburglar::InvalidURL)
    end
  end

  describe "#initialize" do
    describe "sets @params" do
      before :each do
        @params = @gateway.instance_variable_get(:@params)
      end
      it { @params.should be_a Hash }
      it { @params.should have_key :foo }
      it "merges Hamburglar.config.credentials" do
        Hamburglar.config.credentials.keys.each do |key|
          @params.should have_key key
        end
      end

      it "overwrites Hamburglar.config.credentials" do
        gateway = Hamburglar::Gateways::Base.new(:foo => :bar, :license_key => 's3cretz')
        gateway.class.set_api_url "http://example.com"
        params = gateway.instance_variable_get(:@params)
        params.should have_key :license_key
        params[:license_key].should == 's3cretz'
      end
    end

    %w[errors response].each do |var|
      it "sets @#{var} to an empty Hash" do
        @gateway.instance_variable_get("@#{var}").should == {}
      end
    end
  end

  %w[params errors response].each do |attr|
    describe "##{attr}" do
      it { @gateway.should have_attr_reader attr }
      it "returns @#{attr} hash" do
        val = @gateway.send(attr)
        raw = @gateway.instance_variable_get("@#{attr}")
        val.should be_a Hash
        val.should == raw
      end
    end
  end

  describe "#validate" do
    it "returns false if required_params aren't set" do
      should_require_params :one, :two
      @gateway.validate.should == false
    end

    it "returns true if required_params are set" do
      should_require_params :foo
      @gateway.validate.should == true
    end

    it "adds missing params to @errors[:missing_parameters]" do
      should_require_params :one, :two
      @gateway.validate
      missing = @gateway.errors[:missing_parameters]
      missing.should be_an Array
      missing.should have(2).items
      missing.should include :one
      missing.should include :two
    end

    it "ensures @validated is true when done" do
      @gateway.validate
      @gateway.instance_variable_get(:@validated).should == true
    end

    describe "revalidation" do
      before :each do
        should_require_params :one, :two
      end

      it "happens when #validate(true) is called" do
        @gateway.validate.should == false
      end

      it "happens not when #validate is called" do
        @gateway.validate.should == false
        @gateway.params[:one] = 1
        @gateway.params[:two] = 2
        @gateway.validate(true).should == true
      end
    end
  end

  describe "#valid?" do
    it "is an alias for validate" do
      @gateway.method(:valid?).should == @gateway.method(:validate)
    end
  end

  describe "#validate!" do
    it "raises InvalidRequest if validation fails" do
      should_require_params :one, :two
      expect { @gateway.validate! }.to raise_error Hamburglar::InvalidRequest
    end
  end

  describe "#submit" do
    before :each do
      @gateway.class.set_api_url 'http://example.com/foo/bar'
    end

    it "returns false if validate returns false" do
      should_require_params :bar
      @gateway.class.new.submit.should == false
    end

    it "returns the HTTP data" do
      mock_request('http://example.com/foo/bar?license_key=s3cretz&foo=bar', :status => ['200', 'OK'], :body => 'key1=val1;key2=val2')
      should_require_params :foo
      res = @gateway.submit
      res.should be_a Hash
      res.should have(2).items
    end
  end

  describe "#query_string (private)" do
    it "formats @params into a string for URL submission" do
      @gateway.instance_eval('query_string').should include 'foo=bar'
    end
  end

  describe "#parse_response (private)" do
    before :each do
      data = %{key1=val1;key2=val2;key3=val3;}
      @hash = @gateway.instance_eval { parse_response(data) }
    end

    it "returns a hash" do
      @hash.should be_a Hash
    end

    it "has keys/values from data" do
      1.upto(3) do |i|
        @hash.should have_key :"key#{i}"
        @hash[:"key#{i}"].should == "val#{i}"
      end
    end

    it "handles invalid input" do
      @gateway.instance_eval { parse_response('foo=;=bar;==;;') }.should == {}
    end
  end
end
