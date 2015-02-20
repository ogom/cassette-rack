require 'kramdown'
require_relative 'decorator/request'
require_relative 'decorator/response'

module CassetteRack
  class Drawer
    attr_reader :name

    def initialize(name, options={})
      @name = name
    end

    def cassette
      @cassette ||= VCR::Cassette.new(name)
    end

    def render
      Kramdown::Document.new(self.pull).to_html
    end

    def delete
      File.delete cassette.file if self.exist?
    end

    def exist?
      File.exist?(cassette.file)
    end

    def pull
      request = CassetteRack::Decorator::Request.new(http.request)
      response = CassetteRack::Decorator::Response.new(http.response)

      template = Liquid::Template.parse(CassetteRack::Configure.content_template)
      template.render('title' => name, 'request' => request, 'response' => response)
    end

    def http
      cassette.http_interactions.interactions.last
    end
  end
end
