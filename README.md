# Mifiel

[![Gem Version][gem-version-image]][gem-version-url]
[![Build Status][travis-image]][travis-url]
[![security][security-image]][security-url]

Ruby SDK for [Mifiel](https://www.mifiel.com) API.
Please read our [documentation](https://www.mifiel.com/api-docs/) for instructions on how to start using the API.

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

To start using the API you will need an APP_ID and a APP_SECRET which will be provided upon request (contact us at hola@mifiel.com).

You will first need to create an account in [mifiel.com](https://www.mifiel.com) since the APP_ID and APP_SECRET will be linked to your account.

Then you can configure the gem with:

```ruby
  Mifiel.config do |config|
    config.app_id = '<APP_ID>'
    config.app_secret = '<APP_SECRET>'
  end
```

Document methods:

- Find:

```ruby
  document = Mifiel::Document.find('id')
  document.original_hash
  document.file
  document.file_signed
  # ...
```

- Find all:

```ruby
  documents = Mifiel::Document.all
```

- Create:

```ruby
  document = Mifiel::Document.create(
    file: 'path/to/my-file.pdf',
    signatories: [
      { name: 'Signer 1', email: 'signer1@email.com', tax_id: 'AAA010101AAA' },
      { name: 'Signer 2', email: 'signer2@email.com', tax_id: 'AAA010102AAA' }
    ]
  )
```

- Sign:
  + With a pre-created Certificate

    ```ruby
      certificate = Mifiel::Certificate.find('cert-id')
      document.sign(certificate_id: certificate.id)
    ```

  + With a new one

    ```ruby
      document.sign(certificate: File.read('FIEL_AAA010101AAA.cer'))
    ```

- Delete

  ```ruby
    document.delete
  ```

Certificate methods:

- Sat Certificates

  ```ruby
    sat_certificates = Mifiel::Certificate.sat
  ```

- Find:

```ruby
  certificate = Mifiel::Certificate.find('id')
  certificate.cer_hex
  certificate.type_of
  # ...
```

- Find all:

```ruby
  certificates = Mifiel::Certificate.all
```

- Create
  
  ```ruby
  certificate = Mifiel::Certificate.create(
    file: 'path/to/my-certificate.cer'
  )
  ```

- Delete

  ```ruby
    certificate.delete
  ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mifiel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


[gem-version-image]: https://badge.fury.io/rb/mifiel.svg
[gem-version-url]: https://badge.fury.io/rb/mifiel
[security-url]: https://hakiri.io/github/Mifiel/ruby-api-client/master
[security-image]: https://hakiri.io/github/Mifiel/ruby-api-client/master.svg
[travis-image]: https://travis-ci.org/Mifiel/ruby-api-client.svg?branch=master
[travis-url]: https://travis-ci.org/Mifiel/ruby-api-client
