module Hamburglar
  # Raised when trying to assign an invalid gateway to Hamburglar.gateway
  class InvalidGateway < StandardError
    def initialize(gateway = nil)
      msg = "Invalid gateway"
      msg << ", #{gateway}" if gateway
      super msg
    end
  end

  # Raised when trying to assign an invalid gateway URL
  class InvalidURL < StandardError
    def initialize(url = nil)
      msg = "Invalid url"
      msg << ", #{url}" if url
      super msg
    end
  end

  # Raised if Hamburglar::Gateways::Base.validate! fails
  class InvalidRequest < StandardError
    def initialize(msg = nil)
      super "Invalid request"
    end
  end
end
