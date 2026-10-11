# Mifiel

[![Gem Version][gem-version-image]][gem-version-url]
[![Build Status][travis-image]][travis-url]
[![Coverage Status][coveralls-image]][coveralls-url]

Ruby SDK for the [Mifiel](https://www.mifiel.com) API.

## Documentation

API reference, guides, and examples:

- English: https://docs.mifiel.com/en/
- Español: https://docs.mifiel.com/es/

This README covers installation and client setup only.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mifiel'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install mifiel
```

## Setup

1. Create an account (production or [sandbox](https://app-sandbox.mifiel.com)).
2. Generate an `APP_ID` and `APP_SECRET` in [Access Tokens](https://app-sandbox.mifiel.com/settings/access-tokens).
3. Configure the gem:

```ruby
Mifiel.config do |config|
  config.app_id = '<APP_ID>'
  config.app_secret = '<APP_SECRET>'
  # Production is the default.
  # For sandbox:
  config.base_url = 'https://app-sandbox.mifiel.com/api/v1'
end
```

## Contributing

1. Fork it (https://github.com/Mifiel/ruby-api-client/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[gem-version-image]: https://badge.fury.io/rb/mifiel.svg
[gem-version-url]: https://badge.fury.io/rb/mifiel
[travis-image]: https://travis-ci.org/Mifiel/ruby-api-client.svg?branch=master
[travis-url]: https://travis-ci.org/Mifiel/ruby-api-client
[coveralls-image]: https://coveralls.io/repos/github/Mifiel/ruby-api-client/badge.svg?branch=master
[coveralls-url]: https://coveralls.io/github/Mifiel/ruby-api-client?branch=master
