module Hamburglar
  # Hamburglar::Report is the main class for generating fraud reports
  class Report
    # Parameters that will be used to generate this fraud report
    attr_reader :params

    # Response from gateway
    attr_reader :response

    def initialize(params = {})
      @gateway  = params.delete(:gateway) || Hamburglar.config.gateway
      @params   = params
      @response = generate_report!
    end

    def method_missing(method, *args, &block)
      if @response && @response[method.to_sym]
        @response[method.to_sym]
      else
        super
      end
    end

    def respond_to?(key)
      @response.has_key?(key) || super
    end

    def fraud?
      @fraud = true if @response.nil? || @response.empty?
      return @fraud if @fraud
      if Hamburglar.config.fraud_proc.nil?
        @fraud = @response[:score].to_f >= Hamburglar.config.fraud_score.to_f
      else
        @fraud = Hamburglar.config.fraud_proc.call(self) == true
      end
    end

  private

    def generate_report!
      api = gateway.new(@params)
      if api.valid?
        api.submit
      else
        api.errors
      end
    end

    def gateway
      case @gateway.to_s
      when /min_fraud/
        Gateways::MaxMind::MinFraud
      when /telephone/
        Gateways::MaxMind::TelephoneVerification
      else
        raise Hamburglar::InvalidGateway, @gateway
      end
    end

  end
end
