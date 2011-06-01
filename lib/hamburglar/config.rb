module Hamburglar
  class Config
    attr_accessor :gateway
    attr_accessor :credentials

    def initialize
      @gateway     = :min_fraud
      @credentials = {}
    end
  end
end
