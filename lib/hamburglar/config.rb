module Hamburglar
  class Config
    attr_accessor :gateway
    attr_accessor :credentials
    attr_accessor :fraud_score

    def initialize
      @gateway     = :min_fraud
      @credentials = {}
      @fraud_score = 2.5
    end
  end
end
