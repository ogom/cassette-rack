require 'rack'

module CassetteRack
  class Engine
    def call(env)
      controller(env)
    end

    class << self
      def prototype
        @prototype ||= new
      end

      def call(env)
        prototype.call(env)
      end
    end

    private
      def controller(env)
        request = Rack::Request.new(env)
        params = Hash[URI.decode_www_form(request.query_string)]
        drawer = CassetteRack::Drawer.new(request.path_info)

        case request.request_method
        when 'DELETE'
          drawer.delete
        end

        case params['response']
        when 'preview'
          template = Liquid::Template.parse(CassetteRack::Configure.preview_template)
          body = template.render('body' => drawer.http.response.body)
        else
          tree = CassetteRack::Tree.create(CassetteRack::Configure.source_path)
          cassettes_tag = render_branch(tree, request.script_name, request.path_info)
          cassette_tag = render_leaf(drawer, request.script_name + request.path_info)

          template = Liquid::Template.parse(CassetteRack::Configure.application_template)
          body = template.render('cassettes_tag' => cassettes_tag, 'cassette_tag' => cassette_tag)
        end

        status = 200
        headers = {'Content-Type' => 'text/html'}
        [status, headers, [body]]
      end

      def render_branch(node, script_name, path_info)
        raw = "<ol #{node.level == 0 ? "id='tree'" : nil}><li>"
        raw += "<label class='branch' for='#{node.id}'>#{node.name}</label>"
        raw += "<input type='checkbox' id='#{node.id}' checked />\n"

        entries = []
        node.entries.each do |entry|
          if entry.leaf?
            entries << entry
          else
            raw += render_branch(entry, script_name, path_info)
          end
        end

        if entries.count > 0
          raw += "<ol>"
          raw += entries.map do |entry|
            raw = "<li class='leaf #{entry.id == path_info ? "active" : nil}'>"
            raw += "<a href=#{script_name}#{entry.id}>#{entry.name}</a></li>"
          end.join("\n")
          raw += "</ol>\n"
        end

        raw += "</li></ol>\n"
        raw
      end

      def render_leaf(drawer, action)
        if drawer.exist?
          raw = drawer.render
          raw += "<div class='btn-group'>\n"
          raw += "<a class='btn btn-primary' href='#{action}?response=preview'>\n"
          raw += "<span>Preview</span></a>\n"
          raw += "<form method='post' action='#{action}'>\n"
          raw += "<input name='_method' value='delete' type='hidden' />\n"
          raw += "<input class='btn btn-danger' type='submit' value='Destroy'>\n"
          raw += "</form>\n"
          raw += "</div>\n"
        else
          raw = "<h3>Please select cassette</h3>"
        end

        raw
      end
    # end private
  end
end
