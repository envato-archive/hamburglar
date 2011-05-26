require 'rspec'
require 'fakeweb'
require 'hamburglar'

def require_params(*params)
  Hamburglar::Gateways::Base.required_params *params
end
