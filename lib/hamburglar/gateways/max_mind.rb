module Hamburglar
  module Gateways
    # The MaxMind module contains classes for working
    # with MaxMind's minFraud and Telephone Verification APIs
    module MaxMind
      # The MinFraud class handles fraud verification
      # through MaxMind's minFraud API.
      #
      # See: http://www.maxmind.com/app/ccv
      class MinFraud < Base
        # The MaxMind API URL
        set_api_url "https://minfraud2.maxmind.com/app/ccv2r"

        # Required parameters for a minFraud API call
        set_required_params :i, :city, :region, :postal, :country, :license_key

        # Optional parameters
        def optional_params
          [
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
        end
      end

      # The TelephoneVerification class handles fraud verification
      # through MaxMind's Telephone Verification API
      #
      # See: http://www.maxmind.com/app/telephone_api
      class TelephoneVerification < Base
        # The MaxMind Telephone Verification API URL
        set_api_url "https://www.maxmind.com/app/telephone_http"

        # Required parameters for a Telephone Verification API call
        set_required_params :l, :phone

        # Optional parameters
        def optional_params
          [:l, :phone, :verify_code].freeze
        end
      end

    end
  end
end
