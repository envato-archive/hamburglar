module Hamburglar
  module Gateways
    # The Hamburglar::Gateways::FraudGuardian class handles fraud verification
    # through FraudGuardian's API.
    #
    # See: http://www.modernbill.com/products/fraudguardian/api/
    class FraudGuardian < Base
      set_api_url "https://www.fraudguardian.com"

      set_required_params :i, :domain, :city, :region, :postal, :country, :login, :pass

      def optional_params
        [
          :i,
          :domain,
          :city,
          :region,
          :postal,
          :country,
          :login,
          :pass,
          :do_whois,
          :send_to,
          :bin,
          :output,
          :email,
          :do_map
        ].freeze
      end
    end
  end
end
