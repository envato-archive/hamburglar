module Hamburglar
  # Hamburglar::Report is the main class for generating fraud reports
  class Report
    # Parameters that will be used to generate this fraud report
    attr_reader :params

    def initialize(params = {})
      @gateway = params.delete(:gateway) || Hamburglar.config.gateway
      @params  = params
      @report  = generate_report!
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
      case @gateway
      when :max_mind_min_fraud
        Gateways::MaxMind::MinFraud
      when :max_mind_telephone
        Gateways::MaxMind::TelephoneVerification
      end
    end

  end
end
