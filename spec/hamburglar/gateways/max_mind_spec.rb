require 'spec_helper'

describe Hamburglar::Gateways::MaxMind do
  describe "::Base" do
    before :each do
      @gateway = Hamburglar::Gateways::MaxMind::Base.new(:foo => :bar)
      @gateway.class.set_api_url "http://example.com"
    end

    describe "::URL_REGEX" do
      reg = Hamburglar::Gateways::MaxMind::Base::URL_REGEX
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

  describe "::MinFraud" do
    before :each do
      @min_fraud = Hamburglar::Gateways::MaxMind::MinFraud.new
    end

    describe "::required_params" do
      [:i, :city, :region, :postal, :country, :license_key].each do |p|
        it { @min_fraud.class.required_params.should include p }
      end
    end

    describe "#initialize" do
      it "translates params[:ip] to params[:i]" do
        fraud = @min_fraud.class.new(:ip => '127.1.1.1')
        params = fraud.instance_variable_get(:@params)
        params.should have_key :i
        params.should_not have_key :ip
        params[:i].should == '127.1.1.1'
      end
    end

    describe "#submit" do
      describe "with invalid license key" do
        use_vcr_cassette "max_mind/min_fraud/submit_invalid_license_key"
        it "returns an error" do
          min = @min_fraud.class.new(MinFraudTest.params)
          min.submit
          min.response[:err].should match /INVALID_LICENSE/
        end
      end
      describe "with valid params" do
        use_vcr_cassette "max_mind/min_fraud/submit_ok"
        it "returns the fraud report hash" do
          min = @min_fraud.class.new(MinFraudTest.params)
          min.submit
          min.response[:distance].should_not be_nil
        end
      end
    end
  end

  describe "::TelephoneVerification" do
    before :each do
      @phone = Hamburglar::Gateways::MaxMind::TelephoneVerification.new
    end

    describe "#initialize" do
      it "merges credentials, if the key is in optional_params" do
        Hamburglar.config.credentials[:license_key] = 'foobar'
        @phone.params.should_not have_key :license_key
      end

      it "translates params[:license_key] to params[:l]" do
        fraud = @phone.class.new(:license_key => 's3cretz')
        params = fraud.instance_variable_get(:@params)
        params.should have_key :l
        params.should_not have_key :license_key
        params[:l].should == 's3cretz'
      end
    end

    describe "::required_params" do
      [:l, :phone].each do |p|
        it { @phone.class.required_params.should include p }
      end
    end

    describe "#submit" do
      describe "with invalid license key" do
        use_vcr_cassette "max_mind/telephone_verification/submit_invalid_license_key"
        it "returns an error" do
          min = @phone.class.new(TelephoneVerificationTest.params)
          min.submit.should be_a Hash
          min.response[:err].should match /Invalid/
        end
      end

      describe "with valid params" do
        use_vcr_cassette "max_mind/telephone_verification/submit_ok"
        it "returns the verification hash" do
          min = @phone.class.new(TelephoneVerificationTest.params)
          min.submit.should be_a Hash
          min.response[:refid].should_not be_nil
        end
      end
    end
  end
end
