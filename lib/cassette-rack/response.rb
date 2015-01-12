module CassetteRack
  class Response
    attr_reader :status, :headers, :body, :method

    def initialize(response)
      @status = response.status
      @headers = response.headers
      @body = response.body
    end

    def status_code
      status
    end

    def response_headers
      headers
    end
  end
end
