require 'faraday'
require 'cassette-rack/response'

module CassetteRack
  module Request
    def get(path, params=nil, headers=nil)
      request(:get, path, params, headers)
    end

    def post(path, body, headers=nil)
      request(:post, path, nil, headers, body)
    end

    def patch(path, body, headers=nil)
      request(:patch, path, nil, headers, body)
    end

    def put(path, body=nil, headers=nil)
      request(:put, path, nil, headers, body)
    end

    def delete(path)
      request(:delete, path)
    end

    def request(method, path, params=nil, headers=nil, body=nil, options=nil)
      conn = Faraday.new(url: CassetteRack.config.url, headers: headers)
      res = conn.send(method) do |req|
        case method
        when :get, :delete
          req.url path
        when :post, :patch, :put
          req.path = path
          req.body = body
        end
      end

      @response = CassetteRack::Response.new(res)
    end

    def response
      @response
    end
  end
end
