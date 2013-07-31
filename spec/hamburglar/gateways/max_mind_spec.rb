# encoding: UTF-8

require 'spec_helper'

class Hamburglar::Gateways::MaxMind::Base
  API_URL  = "http://example.com"
  API_PATH = "/path"
end

describe Hamburglar::Gateways::MaxMind do
  describe "::ResponseParser" do
    subject { Hamburglar::Gateways::MaxMind::Base::ResponseParser.new }

    specify { subject.parse(%{key1=val1;key2=val2;key3=val3;})
      .should == { key1: 'val1', key2: 'val2', key3: 'val3' } }

    specify { subject.parse('foo=;=bar;==;;').should == {} }

    specify { subject.parse('foo=áccént'.encode('ISO-8859-1'))
      .should == { foo: 'áccént'.encode('UTF-8') } }
  end

  describe Hamburglar::Gateways::MaxMind::Base do
    let(:described_class) { Hamburglar::Gateways::MaxMind::Base }

    before do
      described_class.set_required_params(:foo)
    end

    describe "#submit" do
      it "returns false if validate returns false" do
        described_class.new.submit.should be_false
      end

      context "ok" do
        use_vcr_cassette "max_mind/base/submit_ok"

        it "returns the HTTP data" do
          described_class.new(:foo => :bar).submit
            .should == { key1: 'val1', key2: 'val2' }
        end
      end
    end
  end

  describe Hamburglar::Gateways::MaxMind::MinFraud do
    let(:described_class) { Hamburglar::Gateways::MaxMind::MinFraud }

    describe "::required_params" do
      [:i, :city, :region, :postal, :country, :license_key].each do |p|
        it { described_class.required_params.should include p }
      end
    end

    describe "#initialize" do
      it "translates params[:ip] to params[:i]" do
        fraud = described_class.new(:ip => '127.1.1.1')
        fraud.params.should_not have_key :ip
        fraud.params[:i].should == '127.1.1.1'
      end
    end

    describe "#submit" do
      describe "with invalid license key" do
        use_vcr_cassette "max_mind/min_fraud/submit_invalid_license_key"
        it "returns an error" do
          min = described_class.new(MinFraudTest.params)
          min.submit
          min.response[:err].should match /INVALID_LICENSE/
        end
      end
      describe "with valid params" do
        use_vcr_cassette "max_mind/min_fraud/submit_ok"
        it "returns the fraud report hash" do
          min = described_class.new(MinFraudTest.params)
          min.submit
          min.response[:distance].should_not be_nil
        end
      end
    end
  end

  describe Hamburglar::Gateways::MaxMind::TelephoneVerification do
    let(:described_class) { Hamburglar::Gateways::MaxMind::TelephoneVerification }

    describe "#initialize" do
      it "merges credentials, if the key is in optional_params" do
        Hamburglar.config.credentials[:license_key] = 'foobar'
        described_class.new.params.should_not have_key :license_key
      end

      it "translates params[:license_key] to params[:l]" do
        fraud = described_class.new(:license_key => 's3cretz')
        fraud.params.should_not have_key :license_key
        fraud.params[:l].should == 's3cretz'
      end
    end

    describe "::required_params" do
      [:l, :phone].each do |p|
        it { described_class.required_params.should include p }
      end
    end

    describe "#submit" do
      describe "with invalid license key" do
        use_vcr_cassette "max_mind/telephone_verification/submit_invalid_license_key"
        it "returns an error" do
          min = described_class.new(TelephoneVerificationTest.params)
          min.submit.should be_a Hash
          min.response[:err].should match /Invalid/
        end
      end

      describe "with valid params" do
        use_vcr_cassette "max_mind/telephone_verification/submit_ok"
        it "returns the verification hash" do
          min = described_class.new(TelephoneVerificationTest.params)
          min.submit.should be_a Hash
          min.response[:refid].should_not be_nil
        end
      end
    end
  end
end
