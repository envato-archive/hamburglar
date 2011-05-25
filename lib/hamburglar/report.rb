module Hamburglar
  # The Hamburglar::Report is the main class for generating fraud
  # reports
  class Report
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

  end
end
