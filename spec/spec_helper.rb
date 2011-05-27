require 'rspec'
require 'fakeweb'
require 'hamburglar'

FakeWeb.allow_net_connect = false

def require_params(*params)
  Hamburglar::Gateways::Base.required_params *params
end

def mock_request(url, options = {})
  FakeWeb.register_uri(:get, url, options)
end
