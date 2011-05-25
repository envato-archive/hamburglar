module Hamburglar
  # Raised when trying to assign an invalid gateway to
  # Hamburglar.gateway
  class InvalidGateway < StandardError
    def initialize(gateway = nil)
      msg = "Invalid gateway"
      msg << ", #{gateway}" if gateway
      super msg
    end
  end
end
