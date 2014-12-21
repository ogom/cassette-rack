module CassetteRack
  module Default
    CASSETTE_EXTENSION = 'yml'.freeze
    CASSETTE_PATH = 'spec/cassettes'.freeze

    class << self
      def options
        Hash[CassetteRack::Configure.keys.map{|key| [key, send(key)]}]
      end

      def cassette_extension
        CASSETTE_EXTENSION
      end

      def cassette_path
        CASSETTE_PATH
      end
    end
  end
end
