module Hamburglar
  module Gateways
    # Hamburglar::Gateways::Base is the main class that handles sending API
    # requests to upstream providers. All other gateways should inherit from
    # this class
    class Base
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
        @params   = Hash[Hamburglar.config.credentials].merge(params)
        @errors   = {}
        @response = {}
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

      # Subclasses need to implement this.
      def submit
        raise NotImplementedError
      end
    end
  end
end
