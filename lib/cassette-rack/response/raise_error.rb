require 'faraday'

module CassetteRack
  class Response
    class RaiseError < Faraday::Response::Middleware
      def on_complete(env)
        if error = CassetteRack::Response::Error.status(env)
          raise error
        end
      end
    end

    class Error < StandardError
      attr_reader :response

      def self.status(env)
        if klass =
          case env[:status]
          when 400      then Response::Error::BadRequest
          when 401      then Response::Error::Unauthorized
          when 403      then Response::Error::Forbidden
          when 404      then Response::Error::NotFound
          when 405      then Response::Error::MethodNotAllowed
          when 406      then Response::Error::NotAcceptable
          when 409      then Response::Error::Conflict
          when 415      then Response::Error::UnsupportedMediaType
          when 422      then Response::Error::UnprocessableEntity
          when 400..499 then Response::Error::ClientError
          when 500      then Response::Error::InternalServerError
          when 501      then Response::Error::NotImplemented
          when 502      then Response::Error::BadGateway
          when 503      then Response::Error::ServiceUnavailable
          when 500..599 then Response::Error::ServerError
          end
          klass.new(env)
        end
      end

      def initialize(response)
        @response = response

        str = response[:body]
        if response.request_headers['accept'] == 'application/json'
          begin
            body = JSON.parse(response[:body])
            str = body['message'] if body.key?('message')
            str = body['error_message'] if body.key?('error_message')
          rescue
          end
        end

        super(str)
      end

      def response_status
        response[:status]
      end

      def response_body
        response[:body]
      end
    end

    class Response::Error::BadRequest           < CassetteRack::Response::Error; end
    class Response::Error::Unauthorized         < CassetteRack::Response::Error; end
    class Response::Error::Forbidden            < CassetteRack::Response::Error; end
    class Response::Error::NotFound             < CassetteRack::Response::Error; end
    class Response::Error::MethodNotAllowed     < CassetteRack::Response::Error; end
    class Response::Error::NotAcceptable        < CassetteRack::Response::Error; end
    class Response::Error::Conflict             < CassetteRack::Response::Error; end
    class Response::Error::InternalServerError  < CassetteRack::Response::Error; end
    class Response::Error::NotImplemented       < CassetteRack::Response::Error; end
    class Response::Error::BadGateway           < CassetteRack::Response::Error; end
    class Response::Error::UnprocessableEntity  < CassetteRack::Response::Error; end
    class Response::Error::ServiceUnavailable   < CassetteRack::Response::Error; end
  end
end
