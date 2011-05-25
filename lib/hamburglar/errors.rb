module Hamburglar
  # Raised when trying to assign an invalid gateway to
  # Hamburglar.gateway
  class InvalidGateway < StandardError
    def initialize(gateway = '')
      super "Invalid gateway, #{gateway}"
    end
  end
end
