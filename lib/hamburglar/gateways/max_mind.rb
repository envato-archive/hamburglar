module Hamburglar
  module Gateways
    class MaxMind < Base
      # The MaxMind API URL
      # TODO: Switch to https
      api_url "http://minfraud2.maxmind.com/app/ccv2r"
    end
  end
end
