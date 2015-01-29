module CassetteRack
  module Default
    CASSETTE_PATH = 'spec/cassettes'.freeze
    URL = 'http://localhost:3000'.freeze

    class << self
      def options
        Hash[CassetteRack::Configure.keys.map{|key| [key, send(key)]}]
      end

      def cassette_path
        CASSETTE_PATH
      end

      def url
        URL
      end
    end
  end
end
