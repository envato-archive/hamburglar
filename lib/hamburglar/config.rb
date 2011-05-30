module Hamburglar
  class Config
    attr_reader :gateway
    attr_accessor :credentials

    def initialize
      @gateway     = :max_mind_min_fraud
      @credentials = {}
    end

    # Set the gateway to be used for fraud reports
    def gateway=(gateway)
      unless Hamburglar::GATEWAYS.include? gateway
        raise InvalidGateway, gateway
      end
      @gateway = gateway
    end
  end
end
