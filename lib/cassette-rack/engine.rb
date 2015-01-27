require 'rack'

module CassetteRack
  class Engine
    attr_accessor :request

    def call(env)
      @request = Rack::Request.new(env)
      tree = CassetteRack::Tree.create(CassetteRack::Configure.source_path)

      status = 200
      headers = {'Content-Type' => 'text/html'}
      body = render_application(render_branch(tree), render_leaf(request.path_info))

      [status, headers, [body]]
    end

    private
      def render_application(cassettes_tag, cassette_tag)
        template = Liquid::Template.parse(CassetteRack::Configure.application_template)
        template.render('cassettes_tag' => cassettes_tag, 'cassette_tag' => cassette_tag)
      end

      def render_branch(node)
        raw = "<ol #{node.level == 0 ? "id='tree'" : nil}><li>"
        raw += "<label class='branch' for='#{node.id}'>#{node.name}</label>"
        raw += "<input type='checkbox' id='#{node.id}' checked />\n"

        entries = []
        node.entries.each do |entry|
          if entry.leaf?
            entries << entry
          else
            raw += render_branch(entry)
          end
        end

        if entries.count > 0
          raw += "<ol>"
          raw += entries.map do |entry|
            raw = "<li class='leaf #{entry.id == request.path_info ? "active" : nil}'>"
            raw += "<a href=#{request.script_name}#{entry.id}>#{entry.name}</a></li>"
          end.join("\n")
          raw += "</ol>\n"
        end

        raw += "</li></ol>\n"
        raw
      end

      def render_leaf(path)
        drawer = CassetteRack::Drawer.new(path)
        Kramdown::Document.new(drawer.pull).to_html
      end
    # end private

    class << self
      def prototype
        @prototype ||= new
      end

      def call(env)
        prototype.call(env)
      end
    end
  end
end
