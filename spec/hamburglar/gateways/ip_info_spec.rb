require 'spec_helper'

describe Hamburglar::Gateways::IpInfoDb do
  describe "::FraudDetection" do
    before :each do
      @fraud_detection = Hamburglar::Gateways::IpInfoDb::FraudDetection.new
    end

    describe "#optional_params" do
      it { @fraud_detection.optional_params.should be_an Array }
      it { @fraud_detection.optional_params.should be_frozen }
    end

    describe "::required_params" do
      [:key, :ip, :country_code].each do |p|
        it { @fraud_detection.class.required_params.should include p }
      end
    end

    describe "::api_url" do
      reg = Hamburglar::Gateways::Base::URL_REGEX
      it { @fraud_detection.class.api_url.should match reg }
    end

    describe "#submit" do
      describe "with invalid license key" do
        use_vcr_cassette "ip_info/fraud_detection/submit_invalid_license_key"
        it "returns an error" do
          min = @fraud_detection.class.new(IpInfoTest.params)
          min.params[:key] = 'aaa'
          min.submit
          min.response[:errors].should match /Invalid API key/
        end
      end
      describe "with valid params" do
        use_vcr_cassette "ip_info/fraud_detection/submit_ok"
        it "returns the fraud report hash" do
          min = @fraud_detection.class.new(IpInfoTest.params)
          min.submit
          min.response[:score].should_not be_nil
        end
      end
    end
  end

end
