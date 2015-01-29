require 'vcr'

module CassetteRack
  module Configure
    class << self
      attr_accessor :cassette_extension, :cassette_path, :url

      def setup
        keys.each do |key|
          instance_variable_set(:"@#{key}", CassetteRack::Default.send(key))
        end

        FileUtils.mkdir_p(self.source_path)

        VCR.configure do |config|
          config.cassette_library_dir = self.source_path
        end
      end

      def keys
        @keys ||= %i[cassette_extension cassette_path url]
      end

      def source_path
        @source_path ||= File.expand_path(self.cassette_path)
      end

      def templates_path
        @templates_path ||= CassetteRack.root.join('lib', 'templates').to_s
      end

      def application_layout
        @application_layout ||= File.expand_path('application.html.liquid', File.join(self.templates_path, 'layouts'))
      end

      def content_layout
        @content_layout ||= File.expand_path('content.md.liquid', File.join(self.templates_path, 'layouts'))
      end

      def preview_layout
        @preview_layout ||= File.expand_path('preview.liquid', File.join(self.templates_path, 'layouts'))
      end

      def application_template
        File.read(self.application_layout)
      end

      def content_template
        File.read(self.content_layout)
      end

      def preview_template
        File.read(self.preview_layout)
      end
    end
  end
end
