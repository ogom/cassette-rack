require_relative 'decorator/request'
require_relative 'decorator/response'

module CassetteRack
  class Drawer
    attr_reader :name

    def initialize(name, options={})
      @name = name
    end

    def pull
      request = CassetteRack::Decorator::Request.new(cassette.request)
      response = CassetteRack::Decorator::Response.new(cassette.response)

      template = Liquid::Template.parse(CassetteRack::Configure.content_template)
      template.render('title' => name, 'request' => request, 'response' => response)
    end

    def cassette
      @cassette ||= VCR::Cassette.new(name).http_interactions.interactions.first
    end
  end
end
