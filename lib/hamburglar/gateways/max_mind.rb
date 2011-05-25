module Hamburglar
  module Gateways
    class MaxMind < Base
      # The MaxMind API URL
      # TODO: Switch to https
      api_url "http://minfraud2.maxmind.com/app/ccv2r"

      # Required parameters for a MaxMind API call
      required_params :i, :city, :region, :postal, :country, :license_key
    end
  end
end
