# Hamburglar

Hamburglar helps you prevent fraudulent orders.

## Prerequisites

You must have an active account with one of the APIs Hamburglar
supports. See `Supported APIs` below.

## Installation

    gem install hamburglar

## Usage

To get a fraud report, create a new instance of the `Hamburglar::Report`
class:

    # Check for fraud
    report = Hamburglar::Report.new(params)
    report.fraud?

### MaxMind

Hamburglar uses MaxMind's MinFraud API to generate reports.

    report = Hamburglar::Report.new(
      :i             => '192.168.1.1',
      :city          => 'Funland',
      :region        => 'US',
      :postal        => '12345',
      :country       => 'US',
      :bin           => '12345',
      :domain        => 'example.com',
      :binName       => 'Happy Meal Bank',
      :cust_phone    => '+18004445555',
      :email_address => 'test@example.com'
    )

## Supported APIs

* [MaxMind MinFraud](http://www.maxmind.com/app/ccv/)

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
