require 'pathname'

require_relative 'cassette-rack/version'
require_relative 'cassette-rack/configure'
require_relative 'cassette-rack/default'
require_relative 'cassette-rack/engine'
require_relative 'cassette-rack/tree'
require_relative 'cassette-rack/drawer'

module CassetteRack
  class << self
    def configure
      yield CassetteRack::Configure
    end

    def config
      CassetteRack::Configure
    end

    def root
      @root ||= Pathname.new(File.expand_path('..', File.dirname(__FILE__)))
    end
  end
end

CassetteRack::Configure.setup
