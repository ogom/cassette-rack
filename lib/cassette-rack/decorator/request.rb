module CassetteRack
  module Decorator
    class Request
      def initialize(request)
        @request = request
      end

      def to_liquid
        {
          'method' => method,
          'path' => path
        }
      end

      def method
        @request.method.to_s.upcase
      end

      def path
        URI.parse(@request.uri).path
      end
    end
  end
end

