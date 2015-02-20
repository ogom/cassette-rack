# CassetteRack

Operate of the VCR cassette on Rack.

![caracal](https://dl.dropboxusercontent.com/u/14690051/images/logo/caracal.png)

Caracal is cassette rack alchemist.

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
