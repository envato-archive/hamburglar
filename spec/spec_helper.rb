require 'rspec'
require 'fakeweb'
require 'hamburglar'

FakeWeb.allow_net_connect = false

def should_require_params(*params)
  if params.count > 0
    Hamburglar::Gateways::Base.required_params *params
  end
  Hamburglar::Gateways::Base.required_params.should == params
end

def mock_request(url, options = {})
  FakeWeb.register_uri(:get, url, options)
end
