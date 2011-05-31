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

def should_require_params(*params)
  @gateway.class.set_required_params *params
  @gateway.class.required_params.should == params
end

def should_be_attr_accessor(key, obj, val = 'foobar')
  describe "attr_accessor :#{key}" do
    should_be_attr_reader key, obj, val
    should_be_attr_writer key, obj, val
  end
end

def should_be_attr_reader(key, obj, val = 'foobar')
  describe "attr_reader :#{key}" do
    it { obj.should respond_to key.to_sym }
    it "gets @#{key}" do
      obj.send(key).should == obj.instance_variable_get("@#{key}")
    end
  end
end

def should_be_attr_writer(key, obj, val = 'foobar')
  describe "attr_writer :#{key}" do
    it { obj.should respond_to "#{key}=".to_sym }
    it "sets @#{key}" do
      obj.send("#{key}=", val)
      obj.instance_variable_get("@#{key}").should == val
    end
  end
end

def mock_request(url, options = {})
  FakeWeb.register_uri(:get, url, options)
end
