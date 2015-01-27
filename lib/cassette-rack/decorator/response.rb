module CassetteRack
  module Decorator
    class Response
      def initialize(response)
        @response = response
      end

      def to_liquid
        {
          'status_code' => status_code,
          'status_message' => status_message,
          'body' => body,
        }
      end

      def status_code
        @response.status.code
      end

      def status_message
        @response.status.message
      end

      def body
        JSON.pretty_generate JSON.parse(@response.body)
      rescue
        @response.body
      end
    end
  end
end

