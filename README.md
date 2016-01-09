# Mifiel

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
      document = Mifiel::Document.find('id')
      certificate = Mifiel::Certificate.find('cert-id')
      document.sign(certificate_id: certificate.id)
    ```

  + With a new one

    ```ruby
      document = Mifiel::Document.find('id')
      document.sign(certificate: File.read('FIEL_AAA010101AAA.cer'))
    ```

- Delete

  ```ruby
    document = Mifiel::Document.find('id')
    document.delete
  ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mifiel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
