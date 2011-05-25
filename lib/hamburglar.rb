require 'hamburglar/errors'

module Hamburglar
  autoload :Version, 'hamburglar/version'
  autoload :Report,  'hamburglar/report'
  autoload :Gateway, 'hamburglar/gateway'

  GATEWAYS = [:max_mind, :fraud_guardian].freeze

  class << self

    # Authorization credentials for the gateway in use
    attr_accessor :credentials
  end

  # Set the gateway to be used for fraud reports
  def self.gateway=(gateway)
    unless GATEWAYS.include? gateway
      raise InvalidGateway, gateway
    end
    @gateway = gateway
  end

  # The current gateway
  def self.gateway
    @gateway
  end
end
