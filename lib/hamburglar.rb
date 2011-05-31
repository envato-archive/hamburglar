require 'hamburglar/errors'

module Hamburglar
  autoload :Version,  'hamburglar/version'
  autoload :Config,   'hamburglar/config'
  autoload :Report,   'hamburglar/report'
  autoload :Gateways, 'hamburglar/gateways'

  GATEWAYS = [:max_mind_min_fraud, :max_mind_telephone, :fraud_guardian].freeze

  class << self
    attr_accessor :config
  end

  def self.configure
    yield config if block_given?
    config
  end

  self.config = Config.new
end
