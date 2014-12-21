module CassetteRack
  module Configure
    class << self
      attr_accessor :cassette_extension, :cassette_path

      def setup
        keys.each do |key|
          instance_variable_set(:"@#{key}", CassetteRack::Default.send(key))
        end

        FileUtils.mkdir_p(self.source_path)
      end

      def keys
        @keys ||= %i[cassette_extension cassette_path]
      end

      def source_path
        @source_path ||= File.expand_path(self.cassette_path)
      end

      def templates_path
        @templates_path ||= CassetteRack.root.join('lib', 'templates').to_s
      end

      def application_layout
        @application_layout ||= File.expand_path('application.html.erb', File.join(self.templates_path, 'layouts'))
      end

      def application_template
        File.read(self.application_layout)
      end
    end
  end
end
