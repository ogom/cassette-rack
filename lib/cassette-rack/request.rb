require 'faraday'
require 'cassette-rack/response'

module CassetteRack
  module Request
    attr_reader :request_options

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

    def delete(path, headers=nil)
      request(:delete, path, nil, headers)
    end

    def request(method, path, params=nil, headers=nil, body=nil, options=nil)
      if request_options
        options = request_options
      else
        options = { url: CassetteRack.config.url, headers: headers }
      end

      conn = Faraday.new(options)
      res = conn.send(method) do |req|
        case method
        when :get, :delete
          req.url path
        when :post, :patch, :put
          req.path = path
          req.body = parse_content(body, req)
        end
      end

      @response = CassetteRack::Response.new(res)
    end

    def response
      @response
    end

    def parse_content(body, req)
      if req.headers['content-type'] == 'application/json' and body.class == Hash
        body.to_json
      else
        body
      end
    end
  end
end
