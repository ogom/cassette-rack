#require 'json'

module CassetteRack
  class Response
    attr_reader :status, :headers, :body, :content
    #, :method

    def initialize(res)
      @response = res
      @status = res.status
      @headers = res.headers
      @body = res.body
      parse_content
    end

    def status_code
      status
    end

    def response_headers
      headers
    end

    def success?
      @response.success?
    end

    def permit(*keys)
      case content
      when Hash
        content.select { |key| keys.include? key }
      when Array
        content.map { |item| item.select { |key| keys.include? key } }
      end
    end

    private
      def parse_content
        case body
        when nil, '', ' '
          @content = nil
        when 'true'
          @content = true
        when 'false'
          @content = false
        else
          if @response.env.request_headers['accept'] == 'application/json'
            @content = JSON.parse(body)
          else
            @content = body
          end
        end
      rescue
        @content = body
      end
    # end private
  end
end
