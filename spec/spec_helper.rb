require 'rspec'
require 'fakeweb'
require 'hamburglar'

FakeWeb.allow_net_connect = false

RSpec.configure do |c|
  c.before :each do
    Hamburglar.configure do |c|
      c.gateway     = :max_mind_min_fraud
      c.credentials = { :username => 'bob' }
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
