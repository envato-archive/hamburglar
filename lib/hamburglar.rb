require 'hamburglar/errors'

module Hamburglar
  autoload :Version,  'hamburglar/version'
  autoload :Report,   'hamburglar/report'
  autoload :Gateways, 'hamburglar/gateways'

  GATEWAYS = [:max_mind_min_fraud, :max_mind_telephone].freeze

  class << self
    # The current gateway
    attr_reader :gateway

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

  self.gateway = :max_mind_min_fraud
end
