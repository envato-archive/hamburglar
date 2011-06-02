require 'spec_helper'

describe Hamburglar::Gateways::MaxMind do
  describe "::MinFraud" do
    before :each do
      @min_fraud = Hamburglar::Gateways::MaxMind::MinFraud.new
    end

    describe "#optional_params" do
      it { @min_fraud.optional_params.should be_an Array }
      it { @min_fraud.optional_params.should be_frozen }
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

    describe "#submit" do
      describe "with invalid license key" do
        use_vcr_cassette "max_mind/min_fraud/submit_invalid_license_key"
        it "returns an error" do
          min = Hamburglar::Gateways::MaxMind::MinFraud.new(MinFraudTest.params)
          min.submit
          min.response[:err].should match /INVALID_LICENSE/
        end
      end
      describe "with valid params" do
        use_vcr_cassette "max_mind/min_fraud/submit_ok"
        it "returns the fraud report hash" do
          min = Hamburglar::Gateways::MaxMind::MinFraud.new(MinFraudTest.params)
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

    describe "#optional_params" do
      it { @phone.optional_params.should be_an Array }
      it { @phone.optional_params.should be_frozen }
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
      # TODO: Remove this
      before :each do
        Hamburglar.config.credentials = {}
      end

      describe "with invalid license key" do
        use_vcr_cassette "max_mind/telephone_verification/submit_invalid_license_key"
        it "returns an error" do
          min = Hamburglar::Gateways::MaxMind::TelephoneVerification.new(TelephoneVerificationTest.params)
          min.submit.should be_a Hash
          min.response[:err].should match /Invalid/
        end
      end

      describe "with valid params" do
        use_vcr_cassette "max_mind/telephone_verification/submit_ok"
        it "returns the verification hash" do
          min = Hamburglar::Gateways::MaxMind::TelephoneVerification.new(TelephoneVerificationTest.params)
          min.submit.should be_a Hash
          min.response[:refid].should_not be_nil
        end
      end
    end
  end
end
