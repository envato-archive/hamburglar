require 'spec_helper'

describe Hamburglar::Gateways::MaxMind do
  describe "::MinFraud" do
    before :each do
      @min_fraud = Hamburglar::Gateways::MaxMind::MinFraud.new
    end

    describe "::required_params" do
      [:i, :city, :region, :postal, :country, :license_key].each do |p|
        it { @min_fraud.class.required_params.should include p }
      end
    end

    describe "::api_url" do
      reg = Hamburglar::Gateways::Base::URL_REGEX
      it { @min_fraud.class.api_url.should match reg }
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

    describe "::api_url" do
      reg = Hamburglar::Gateways::Base::URL_REGEX
      it { @phone.class.api_url.should match reg }
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
