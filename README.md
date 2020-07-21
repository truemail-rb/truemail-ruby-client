# <img src='https://repository-images.githubusercontent.com/246571655/128eda80-63af-11ea-8a0e-d1a7b9043c29' height='250' alt='Truemail web API client library for Ruby' />

[![Maintainability](https://api.codeclimate.com/v1/badges/ccc7167f4f49d4a10146/maintainability)](https://codeclimate.com/github/truemail-rb/truemail-ruby-client/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/ccc7167f4f49d4a10146/test_coverage)](https://codeclimate.com/github/truemail-rb/truemail-ruby-client/test_coverage) [![CircleCI](https://circleci.com/gh/truemail-rb/truemail-ruby-client/tree/develop.svg?style=svg)](https://circleci.com/gh/truemail-rb/truemail-ruby-client/tree/develop) [![Gem Version](https://badge.fury.io/rb/truemail-client.svg)](https://badge.fury.io/rb/truemail-client) [![Downloads](https://img.shields.io/gem/dt/truemail-client.svg?colorA=004d99&colorB=0073e6)](https://rubygems.org/gems/truemail-client) [![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

`truemail-client` gem - [Truemail web API](https://github.com/truemail-rb/truemail-rack) client library for Ruby.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Setting global configuration](#setting-global-configuration)
  - [Establishing connection with Truemail API](#establishing-connection-with-truemail-api)
  - [Additional features](#additional-features)
- [Truemail family](#truemail-family)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)
- [Versioning](#versioning)
- [Changelog](CHANGELOG.md)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'truemail-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install truemail-client

## Usage

To have an access for `Truemail::Client` you must configure it first as in the example below:

### Setting global configuration

```ruby
require 'truemail/client'

Truemail::Client.configure do |config|
  # Optional parameter (Boolean). By default it is equal false
  config.secure_connection = true

  # Required parameter (String). It should be a hostname or an ip address where Truemail server runs
  config.host = 'example.com'

  # Optional parameter (Integer). By default it is equal 9292
  config.port = 80

  # Required parameter (String). It should be valid Truemail server access token
  config.token = 'token'
end
```

### Establishing connection with Truemail API

After successful configuration, you can establish connection with Truemail server.

```ruby
Truemail::Client.validate('admin@bestweb.com.ua')
=>  {
      "date": "2020-02-26 17:00:56 +0200",
      "email": "admin@bestweb.com.ua",
      "validation_type": "smtp",
      "success": true,
      "errors": null,
      "smtp_debug": null,
      "configuration": {
        "validation_type_by_domain": null,
        "whitelist_validation": false,
        "whitelisted_domains": null,
        "blacklisted_domains": null,
        "smtp_safe_check": false,
        "email_pattern": "default gem value",
        "smtp_error_body_pattern": "default gem value",
        "not_rfc_mx_lookup_flow": false
      }
    }
```

`Truemail::Client.validate` always returns JSON data. If something goes wrong you will receive JSON with error details:

```json
{
  "truemail_client_error": "error details"
}
```

### Additional features

#### Read global configuration

After successful configuration, you can read current `Truemail::Client` configuration instance anywhere in your application.

```ruby
Truemail::Client.configuration
=> #<Truemail::Client::Configuration:0x000055eafc588878
  @host="example.com",
  @port=80,
  @secure_connection=true,
  @token="token">
```

#### Update global configuration

```ruby
Truemail::Client.configuration.port = 8080
=> 8080

Truemail::Client.configuration
=> #<Truemail::Client::Configuration:0x000055eafc588878
  @host="example.com",
  @port=8080,
  @secure_connection=true,
  @token="token">
```

#### Reset global configuration

Also you can reset Truemail::Client configuration.

```ruby
Truemail::Client.reset_configuration!
=> nil
Truemail::Client.configuration
=> nil
```

---

## Truemail family

All Truemail extensions: https://github.com/truemail-rb

| Name | Type | Description |
| --- | --- | --- |
| [truemail](https://github.com/rubygarage/truemail) | ruby gem | Configurable framework agnostic plain Ruby email validator, main core |
| [truemail server](https://github.com/truemail-rb/truemail-rack) | ruby app | Lightweight rack based web API wrapper for Truemail |
| [truemail-rack-docker](https://github.com/truemail-rb/truemail-rack-docker-image) | docker image | Lightweight rack based web API [dockerized image](https://hub.docker.com/r/truemail/truemail-rack) :whale: of Truemail server |
| [truemail-crystal-client](https://github.com/truemail-rb/truemail-crystal-client) | crystal shard | Truemail web API client library for Crystal |
| [truemail-rspec](https://github.com/truemail-rb/truemail-rspec) | ruby gem | Truemail configuration and validator RSpec helpers |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/truemail-rb/truemail-ruby-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. Please check the [open tikets](https://github.com/truemail-rb/truemail-ruby-client/issues). Be shure to follow Contributor Code of Conduct below and our [Contributing Guidelines](CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `truemail-ruby-client` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Versioning

`truemail-ruby-client` uses [Semantic Versioning 2.0.0](https://semver.org)
