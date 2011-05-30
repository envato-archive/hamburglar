require 'rspec'
require 'fakeweb'
require 'hamburglar'

FakeWeb.allow_net_connect = false

def should_require_params(*params)
  @gateway.class.set_required_params *params
  @gateway.class.required_params.should == params
end

def mock_request(url, options = {})
  FakeWeb.register_uri(:get, url, options)
end
