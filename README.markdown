# Hamburglar [![Hamburglar Build Status][Build Icon]][Build Status]

Hamburglar helps you prevent fraudulent orders.

Hamburglar has been tested on MRI 1.9.3, MRI 2.0.0 and 1.9-compatible JRuby.

[Build Icon]: https://secure.travis-ci.org/site5/hamburglar.png?branch=master
[Build Status]: http://travis-ci.org/site5/hamburglar

## Prerequisites

You must have an active account with one of the APIs Hamburglar
supports. See **Supported APIs** below.

## Installation

    gem install hamburglar

## Usage

To get a fraud report, create a new instance of the `Hamburglar::Report`
class:

    report = Hamburglar::Report.new(params)

Check for fraud by comparing the fraud score to
`Hamburglar.config.fraud_score`:

    report.fraud?

By default, Hamburglar only considers the numeric fraud score when
trying to determine if an order is fraudulent. If you need more control,
you can configure `Hamburglar.config.fraud_proc`. It should be a block
that returns true when the order should be considered fraudulent.

    Hamburglar.configure do |c|
      c.fraud_proc = lambda do |report|
        report.score > 5 && report.distance > 100
      end
    end

    report.fraud?

### MaxMind

Hamburglar supports MaxMind's minFraud and Telephone Verification APIs.
By default, reports will use the minFraud API.

**Generate a fraud report using minFraud**

    report = Hamburglar::Report.new(
      :license_key   => 's3cr3tz',
      :ip            => '192.168.1.1',
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

**Generate a fraud report using Telephone Verification**

    report = Hamburglar::Report.new(
      :gateway     => :max_mind_telephone,
      :license_key => 's3cr3tz',
      :phone       => '+18004445555'
    )

## Optional Configuration

You may optionally configure the default gateway and credentials
Hamburglar will use. For example, in a Rails app where you always
used minFraud, you can add the following to
`config/initializers/hamburglar.rb`:

    Hamburglar.configure do |config|
      config.fraud_score = 2.5
      config.gateway     = :max_mind_min_fraud
      config.credentials = { :license_key => 's3cr3tz' }
    end

Note that Hamburglar uses a default fraud score of 2.5 and the default
gateway is minFraud.

## Supported APIs

* [MaxMind MinFraud](http://www.maxmind.com/app/ccv/)
* [MaxMind Telephone Verification](http://www.maxmind.com/app/telephone_api)

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version
  unintentionally.
* Commit, do not bump version. (If you want to have your own version, that is
  fine but bump version in a commit by itself I can ignore when I pull.)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2012 Site5.com. See LICENSE for details.
