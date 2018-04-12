# Mifiel

[![Gem Version][gem-version-image]][gem-version-url]
[![Build Status][travis-image]][travis-url]
[![Coverage Status][coveralls-image]][coveralls-url]
[![security][security-image]][security-url]

Ruby SDK for [Mifiel](https://www.mifiel.com) API.
Please read our [documentation](http://docs.mifiel.com/) for instructions on how to start using the API.

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

For your convenience Mifiel offers a Sandbox environment where you can confidently test your code.

To start using the API in the Sandbox environment you need to first create an account at [sandbox.mifiel.com](https://sandbox.mifiel.com).

Once you have an account you will need an APP_ID and an APP_SECRET which you can generate in [sandbox.mifiel.com/access_tokens](https://sandbox.mifiel.com/access_tokens).

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

> Use only **hash** if you dont want us to have the file.<br>
> Either **file** or **hash** must be provided.

```ruby
  document = Mifiel::Document.create(
    file: 'path/to/my-file.pdf',
    signatories: [
      { name: 'Signer 1', email: 'signer1@email.com', tax_id: 'AAA010101AAA' },
      { name: 'Signer 2', email: 'signer2@email.com', tax_id: 'AAA010102AAA' }
    ]
  )
  # if you dont want us to have the PDF, you can just send us 
  # the original_hash and the name of the document. Both are required
  document = Mifiel::Document.create(
    hash: Digest::SHA256.hexdigest(File.read('path/to/my-file.pdf')), 
    name: 'my-file.pdf',
    signatories: [...]
  )
```

- Save Document related files

```ruby
  # save the original file
  document.save_file('path/to/save/file.pdf')
  # save the signed file (original file + signatures page)
  document.save_file_signed('path/to/save/file-signed.pdf')
  # save the signed xml file
  document.save_xml('path/to/save/xml.xml')
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

User methods

- Setup Widget

  ```ruby
    args = {
      email: 'some@email.com',
      tax_id: 'AAA010101AAA',
      callback_url: 'http://some-callback.url'
    }

    user = Mifiel::User.setup_widget(args)
    user.widget_id
  ```

Filtering Results

Our API returns a JSON list of items, this result can be filtered using a `where` method matching a specified criteria (or matching using regular expressions):

```ruby
  document = Mifiel::Document.find('id')
  document.signers.where(field: /receiver|issuer/, email: 'some@email.com')
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

[coveralls-image]: https://coveralls.io/repos/github/Mifiel/ruby-api-client/badge.svg?branch=master
[coveralls-url]: https://coveralls.io/github/Mifiel/ruby-api-client?branch=master
