require 'faraday'
require 'cassette-rack/response'

module CassetteRack
  module TestRequest
    def get(path)
      response = Faraday.get(CassetteRack.config.url + path)
      @response = CassetteRack::Response.new(response)
    end

    def post(path, body, headers=nil)
      response = Faraday.post(CassetteRack.config.url + path, body, headers)
      @response = CassetteRack::Response.new(response)
    end

    def put(path, body, headers=nil)
      response = Faraday.put(CassetteRack.config.url + path, body, headers)
      @response = CassetteRack::Response.new(response)
    end
    alias_method :patch, :put

    def delete(path)
      response = Faraday.delete(CassetteRack.config.url + path)
      @response = CassetteRack::Response.new(response)
    end

    def response
      @response
    end
  end
end
