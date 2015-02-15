# CassetteRack

Operate of the VCR cassette on Rack.

## Installation

Add this line to your application's Gemfile:

```
gem 'cassette-rack'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install cassette-rack
```

## Usage

Add this line to your `config.ru`:

```
require 'cassette-rack'
run CassetteRack::Engine
```

And then execute:

```
$ rackup
```

## License

* MIT
