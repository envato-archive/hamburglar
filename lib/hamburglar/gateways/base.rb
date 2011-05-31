require 'net/https'
require 'cgi'

module Hamburglar
  module Gateways
    # Hamburglar::Gateways::Base is the main class that handles sending API
    # requests to upstream providers. All other gateways should inherit from
    # this class
    class Base

      URL_REGEX = /https?:\/\/[\S]+/

      # The parameters for the API request
      attr_reader :params

      # Errors returned when validating or submitting a request
      attr_reader :errors

      # Response returned by an API call
      attr_reader :response

      class << self
        # The API URL
        attr_reader :api_url
      end

      def initialize(params = {})
        @params   = (Hamburglar.config.credentials || {}).merge(params)
        @errors   = {}
        @response = {}
      end

      # Get or set the API URL for the gateway
      def self.set_api_url(url = '')
        if url.match URL_REGEX
          @api_url = url
        else
          raise Hamburglar::InvalidURL, url
        end
      end

      # Set required parameters for an API call
      def self.set_required_params(*params)
        @required_params = params
      end

      # Required parameters for an API call
      def self.required_params
        @required_params || []
      end

      # Validate presence of required_params
      #
      # Returns false if a parameter isn't set
      def validate(revalidate = false)
        @validated = false if revalidate
        unless @validated
          @errors[:missing_parameters] = []
          self.class.required_params.each do |req|
            unless @params.has_key?(req)
              @errors[:missing_parameters] << req
            end
          end
          @validated = true
        end
        @errors[:missing_parameters].empty?
      end
      alias_method :valid?, :validate

      # Validate presence of required_params
      #
      # Raises Hamburglar::InvalidRequest if validation fails
      def validate!
        validate || raise(Hamburglar::InvalidRequest)
      end

      # Submit a request upstream to generate a fraud report
      def submit
        return false unless valid?
        url = "#{self.class.api_url}?#{query_string}"
        if res = fetch(url)
          @response = parse_response(res.body)
        end
      end

      # Optional parameters that *may* be present in a query
      #
      # This method should be overridden by classes than inherit from
      # Hamburglar::Gateways::Base
      #
      # Defaults to self.required_params
      def optional_params
        self.class.required_params
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
        data = raw.to_s.split(';').map do |line|
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
      #
      # See Following Redirection at
      # http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
      def fetch(uri_str, limit = 10)
        # You should choose better exception.
        raise ArgumentError, 'HTTP redirect too deep' if limit == 0

        uri = URI.parse(uri_str)
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          http.ca_file = File.expand_path('../../../cacert.pem', __FILE__)
        end
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.start { |http| http.request(request) }

        case response
        when Net::HTTPSuccess     then response
        when Net::HTTPRedirection then fetch(response['location'], limit - 1)
        else
          response.error!
        end
      end

    end
  end
end
