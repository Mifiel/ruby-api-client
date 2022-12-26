# Mifiel

[![Gem Version][gem-version-image]][gem-version-url]
[![Build Status][travis-image]][travis-url]
[![Coverage Status][coveralls-image]][coveralls-url]
[![security][security-image]][security-url]

Ruby SDK for [Mifiel](https://www.mifiel.com) API.
Please read our [documentation](https://docs.mifiel.com/) for instructions on how to start using the API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mifiel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mifiel

## Usage

Follow the steps in our [documentation](https://docs.mifiel.com/) to create an account and get your access tokens, then you can configure the gem with:

```ruby
  Mifiel.config do |config|
    config.app_id = '<APP_ID>'
    config.app_secret = '<APP_SECRET>'
    # remove the next line when you wish to use the prod environment
    config.base_url = 'https://app-sandbox.mifiel.com/api/v1'
  end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mifiel/fork )
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
