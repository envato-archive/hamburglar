require 'rspec'
require 'vcr'
require 'fakeweb'
require 'hamburglar'

FakeWeb.allow_net_connect = false

VCR.config do |c|
  c.default_cassette_options = { :record => :new_episodes }
  c.cassette_library_dir     = 'spec/fixtures'
  c.stub_with :fakeweb
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.before :each do
    Hamburglar.configure do |config|
      config.gateway     = :max_mind_min_fraud
      config.credentials = { :license_key => 's3cretz' }
    end
  end
end

class ResponseTest
  def self.response_to_s
    response.map { |key, val| "#{key}=#{val}" }.join(';')
  end
end

class MinFraudTest < ResponseTest
  def self.params
    {
      :i             => '127.0.0.1',
      :city          => 'New York',
      :region        => 'New York',
      :postal        => '12345',
      :country       => 'United States',
      :bin           => '12345',
      :domain        => 'gmail.com',
      :binName       => 'National Bank',
      :cust_phone    => '+12223334444',
      :email_address => 'peter.parker@gmail.com'
    }
  end

  def self.response
    {
      :distance         => "710",
      :countryMatch     => "Yes",
      :countryCode      => "US",
      :freeMail         => "Yes",
      :anonymousProxy   => "No",
      :score            => "2.85",
      :binMatch         => "NotFound",
      :proxyScore       => "0.00",
      :ip_region        => "09",
      :ip_city          => "Funtown",
      :ip_latitude      => "-137.8333",
      :ip_longitude     => "45.0333",
      :ip_isp           => "FOOBAR COMMUNICATIONS",
      :ip_org           => "FOOBAR COMMUNICATIONS",
      :binNameMatch     => "NA",
      :binPhoneMatch    => "NA",
      :highRiskCountry  => "No",
      :queriesRemaining => "9999",
      :maxmindID        => "MAXMINDID",
      :riskScore        => "0.1",
      :explanation      => "This order is slightly risky, and we suggest that you review it manually, especially for B2B transactions. This order is considered to be a little higher risk because the distance between the billing address and the user's actual location is larger than expected. The order is slightly riskier because the e-mail domain, gmail.com, is a free e-mail provider"
    }
  end
end

RSpec::Matchers.define :have_attr_accessor do |attribute|
  match do |object|
    object.respond_to?(attribute) && object.respond_to?("#{attribute}=")
  end

  description do
    "have attr_writer :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_reader do |attribute|
  match do |object|
    object.respond_to? attribute
  end

  description do
    "have attr_reader :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_writer do |attribute|
  match do |object|
    object.respond_to? "#{attribute}="
  end

  description do
    "have attr_writer :#{attribute}"
  end
end

class TelephoneVerificationTest < ResponseTest
  def self.params
    { :l => 's3cretz', :phone => '+15554440000' }
  end
end

def should_require_params(*params)
  @gateway.class.set_required_params *params
  @gateway.class.required_params.should == params
end
