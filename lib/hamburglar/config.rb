module Hamburglar
  class Config
    attr_accessor :gateway
    attr_accessor :credentials
    attr_accessor :fraud_proc

    def initialize
      @gateway     = :min_fraud
      @credentials = {}
      @fraud_proc  = Proc.new do |report|
        report.respond_to?(:score) && report.score < 5
      end
    end
  end
end
