require 'faraday_middleware/response_middleware'

module Hamburglar
  module Gateways
    # The MaxMind module contains classes for working
    # with MaxMind's minFraud and Telephone Verification APIs
    module MaxMind
      class Base < ::Hamburglar::Gateways::Base
        # Parses a MaxMind text response to a hash.
        class ResponseParser < ::FaradayMiddleware::ResponseMiddleware
          define_parser do |body|
            unless body.strip.empty?
              body.split(';').each_with_object({}) do |line, hash|
                key, val = line.split('=')

                if key.to_s != "" && val.to_s != ""
                  hash[key.to_sym] = val
                end
              end
            end
          end
        end

        Faraday.register_middleware :response,
          maxmind: ::Hamburglar::Gateways::MaxMind::Base::ResponseParser

        # Submit a request upstream to generate a fraud report
        def submit
          if valid?
            @response = Faraday.new(:url => self.class::API_URL, ssl: {
              verify: true, ca_file: File.expand_path('../../../cacert.pem', __FILE__)
            }) do |c|
              c.request  :url_encoded
              c.response :raise_error
              c.response :follow_redirects, :limit => 10
              c.response :maxmind
              c.adapter :net_http
            end.post(self.class::API_PATH, @params).body
          end
        end
      end

      # The MinFraud class handles fraud verification
      # through MaxMind's minFraud API.
      #
      # See: http://www.maxmind.com/app/ccv
      class MinFraud < Base
        API_URL  = "https://minfraud2.maxmind.com"
        API_PATH = "/app/ccv2r"

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
        API_URL  = "https://www.maxmind.com"
        API_PATH = "/app/telephone_http"

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
