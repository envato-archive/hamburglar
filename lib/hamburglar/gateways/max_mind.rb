module Hamburglar
  module Gateways
    # The MaxMind module contains classes for working
    # with MaxMind's minFraud and Telephone Verification APIs
    module MaxMind
      class Base < ::Hamburglar::Gateways::Base
        # A regex for matching URLs with http or https
        # This will be used to verify API urls
        URL_REGEX = /https?:\/\/[\S]+/

        # Get or set the API URL for the gateway
        def self.set_api_url(url = '')
          if url.match URL_REGEX
            @api_url = url
          else
            raise Hamburglar::InvalidURL, url
          end
        end

        # Submit a request upstream to generate a fraud report
        def submit
          return false unless valid?
          url = "#{self.class.api_url}?#{query_string}"
          if res = fetch(url)
            @response = parse_response(res.body)
          end
        end

        private

        # Formats @params into a query string for an HTTP GET request
        def query_string
          @params.map { |key, val| "#{key}=#{CGI.escape(val.to_s)}" }.join('&')
        end

        # Parses raw data returned from an API call
        #
        # This method should be overwritten by any API subclasses that
        # return data in a different format
        #
        # Returns [Hash]
        def parse_response(raw = '')
          data = raw.to_s.force_encoding("ISO-8859-1").encode("UTF-8").split(';').map do |line|
            key, val = line.split('=')
            if key.to_s != "" && val.to_s != ""
              [key.to_sym, val]
            else
              next
            end
          end
          Hash[data]
        end

        # Performs a GET request on the given URI, redirects if needed
        def fetch(uri_str, limit = 10)
          # You should choose better exception.
          raise ArgumentError, 'HTTP redirect too deep' if limit == 0
          Faraday.new(:url => uri_str, :ssl => {:verify => true, :ca_file => File.expand_path('../../../cacert.pem', __FILE__)}) do |c|
            c.response :raise_error
            c.response :follow_redirects, :limit => limit
            c.adapter :net_http
          end.get
        end

      end

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
