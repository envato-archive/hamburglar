module Hamburglar
  module Gateways
    # The IpInfoDb module contains classes for working
    # with IpInfoDb's Fraud Detection API
    module IpInfoDb
      # The FraudDetection class handles fraud verification
      # through IpInfoDb's Fraud Detection API.
      #
      # See: http://ipinfodb.com/fraud_detection.php
      class FraudDetection < Base
        # The IpInfoDb Fraud Detection API URL
        set_api_url "http://api.ipinfodb.com/v2/fraud_query.php"

        # Required parameters for a Fraud Detection API call
        set_required_params :key, :ip, :country_code

        # Optional parameters
        def optional_params
          [
            :key,
            :ip,
            :country_code,
            :district,
            :city,
            :area_code,
            :mail_domain,
            :ip_country_match_weight,
            :city_district_match_weight,
            :areacode_district_match_weight,
            :areacode_ip_match_weight,
            :ip_city_distance_weight,
            :ip_city_match,
            :spamhaus_weight,
            :freemail_weight,
            :maxdistance,
            :mincitymatch,
            :enable_hostname
          ].freeze
        end
      
        def parse_response(raw = '')
          require 'crack/xml'
          hash = Crack::XML.parse(raw)['Response']
          Hash[hash.map{ |k, v| [underscore(k.dup).to_sym, v] }]
        end
        
        private

        def underscore(string)
          string.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
        end
      end

    end
  end
end
