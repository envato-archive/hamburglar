module Hamburglar
  module Gateways
    # The Hamburglar::Gateways::FraudGuardian class handles fraud verification
    # through FraudGuardian's API.
    #
    # See: http://www.modernbill.com/products/fraudguardian/api/
    class FraudGuardian < Base
      PARAMS = [
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

      required_params :i, :domain, :city, :region, :postal, :country, :login, :pass

      def initialize
        raise "FraudGuardian is not implemented yet"
      end
    end
  end
end
