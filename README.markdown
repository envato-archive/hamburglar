# Hamburglar

Hamburglar helps you prevent fraudulent orders.

## Usage

    # Configure
    Hamburglar.gateway = :fraud_guardian || :max_mind
    Hamburglar.credentials = { :foo => 'bar' }

    # Check for fraud
    report = Hamburglar::Report.new(params)
    report.fraud?

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version
  unintentionally.
* Commit, do not mess with Rakefile, version, or history. (If you want to have
  your own version, that is fine but bump version in a commit by itself I can
  ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Site5 LLC. See LICENSE for details.
