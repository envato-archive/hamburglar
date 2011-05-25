module Hamburglar
  module Gateways
    class Base

      attr_reader :params

      def initialize(params = {})
        @params = params
        @errors = {}
      end

      # Get or set required parameters for this report
      def self.required_params(*params)
        if params.size > 0
          @required_params = params
        else
          @required_params ||= []
        end
      end

      # Validate presence of required_params
      #
      # Returns false if a parameter isn't set
      def validate!
        self.class.required_params.each do |req|
          return false unless @params.has_key?(req)
        end
        true
      end

      # Submit a request upstream to generate a fraud report
      def submit!
        if Hamburglar.gateway.nil?
          raise Hamburglar::InvalidGateway
        end

        unless validate!
          return false
        end
      end
    end
  end
end
