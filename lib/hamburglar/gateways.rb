module Hamburglar
  # The Hamburglar::Gateways module contains classes used to generate fraud
  # reports
  module Gateways
    autoload :Base,    'hamburglar/gateways/base'
    autoload :MaxMind, 'hamburglar/gateways/max_mind'
  end
end
