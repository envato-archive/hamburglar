module Hamburglar
  module Gateways
    # The Hamburglar::Gateways::MaxMind class handles fraud verification
    # through MaxMind's minFraud API.
    #
    # See: http://www.maxmind.com/app/ccv
    class MaxMind < Base
      PARAMS = [
        :i,
        :city,
        :region,
        :postal,
        :country,
        :license_key,
        :domain,
        :bin,
        :binname,
        :binphone,
        :custphone,
        :requested_type,
        :forwardedip,
        :emailmd5,
        :usernamemd5,
        :passwordmd5,
        :shipaddr,
        :shipcity,
        :shipregion,
        :shippostal,
        :shipcountry,
        :textid,
        :sessionid,
        :user_agent,
        :accept_language
      ].freeze

      # The MaxMind API URL
      # TODO: Switch to https
      api_url "http://minfraud2.maxmind.com/app/ccv2r"

      # Required parameters for a MaxMind API call
      required_params :i, :city, :region, :postal, :country, :license_key
    end
  end
end
