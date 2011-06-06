require 'hamburglar/errors'

module Hamburglar
  autoload :Version,  'hamburglar/version'
  autoload :Config,   'hamburglar/config'
  autoload :Report,   'hamburglar/report'
  autoload :Gateways, 'hamburglar/gateways'

  class << self
    attr_accessor :config
  end

  # Set Hamburglar.config
  #
  # Example:
  #   Hamburglar.configure do |config|
  #     config.fraud_score = 10
  #   end
  def self.configure
    yield config if block_given?
    config
  end

  self.config = Config.new
end
