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

        def initialize(params = {})
          params[:i] = params.delete(:ip) if params[:ip]
          super params
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

        def initialize(params = {})
          super
          self.params[:l] = self.params.delete(:license_key) if self.params[:license_key]
        end
      end

    end
  end
end
