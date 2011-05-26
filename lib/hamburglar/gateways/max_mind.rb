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
        :binName,
        :binPhone,
        :custPhone,
        :requested_type,
        :forwardedIP,
        :emailMD5,
        :usernameMD5,
        :passwordMD5,
        :shipAddr,
        :shipCity,
        :shipRegion,
        :shipPostal,
        :shipCountry,
        :textID,
        :sessionID,
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
