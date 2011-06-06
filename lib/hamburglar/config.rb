module Hamburglar
  # The Hamburglar::Config class stores configuration variables used to generate
  # fraud reports.
  class Config
    # The gateway used when generating fraud reports via
    # `Hamburglar::Report.new`.
    #
    # Example:
    #   # Set gateway
    #   config.gateway = :min_fraud
    #
    #   # Get gateway
    #   config.gateway
    attr_accessor :gateway

    # Credentials that should be used when communicating with
    # upstream APIs.
    #
    # This should be a Hash. When a query is sent to a Gateway, this Hash
    # will be merged in **if** it's keys exist in Gateway#optional_params
    #
    # Example:
    #   # Set credentials:
    #   config.credentials = { :license_key => 's3cretz' }
    #
    #   # Get credentials
    #   config.credentials
    attr_accessor :credentials

    # The score that should be considered fraud. This score will be
    # checked when `Hamburglar::Report#fraud?` is called, unless
    # `config.fraud_proc` is set
    #
    # Example:
    #   # Set fraud score
    #   config.fraud_score = 5
    #
    #   # Get fraud score
    #   config.fraud_score
    attr_accessor :fraud_score

    # An optional Proc that will be used to evaluate
    # `Hamburglar::Report#fraud?` if set
    #
    # Example:
    #   # Set proc
    #   config.fraud_proc = lambda { |report| report.distance > 500 }
    #
    #   # Get proc
    #   config.fraud_proc
    attr_accessor :fraud_proc

    # Create a new Config instance and set some defaults
    def initialize
      @gateway     = :min_fraud
      @credentials = {}
      @fraud_score = 2.5
    end
  end
end
