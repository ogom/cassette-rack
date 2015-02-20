require 'faraday'
require 'cassette-rack/response'

module CassetteRack
  module Request
    attr_reader :request_options

    def get(path, params={}, headers={})
      request(:get, path, params, headers)
    end

    def post(path, body={}, headers={})
      request(:post, path, {}, headers, body)
    end

    def patch(path, body={}, headers={})
      request(:patch, path, {}, headers, body)
    end

    def put(path, body={}, headers={})
      request(:put, path, {}, headers, body)
    end

    def delete(path, headers={})
      request(:delete, path, {}, headers)
    end

    def request(method, path, params={}, headers={}, body={}, options={})
      if request_options
        options = request_options
      else
        options = { url: CassetteRack.config.url, headers: headers }
      end

      conn = Faraday.new(options)
      res = conn.send(method) do |req|
        case method
        when :get, :delete
          req.url path, params
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
      if req.headers['content-type'] == 'application/json' and body.is_a?(Hash)
        body.to_json
      else
        body
      end
    end
  end
end
