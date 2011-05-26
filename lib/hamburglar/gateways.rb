module Hamburglar
  module Gateways
    autoload :Base,          'hamburglar/gateways/base'
    autoload :MaxMind,       'hamburglar/gateways/max_mind'
    autoload :FraudGuardian, 'hamburglar/gateways/fraud_guardian'
  end
end
