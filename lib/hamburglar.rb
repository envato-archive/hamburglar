require 'hamburglar/errors'

module Hamburglar
  autoload :Version, 'hamburglar/version'
  autoload :Report,  'hamburglar/report'

  GATEWAYS = []

  class << self

    # Authorization credentials for the gateway in use
    attr_accessor :credentials

    # The gateway that will be used for fraud reports
    attr_accessor :gateway
  end
end
