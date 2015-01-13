require 'rack'
require 'erb'

module CassetteRack
  class Engine
    attr_accessor :request, :tree

    def call(env)
      @request = Rack::Request.new(env)
      @tree = CassetteRack::Tree.create(CassetteRack::Configure.source_path)

      status = 200
      headers = {'Content-Type' => 'text/html'}
      body = ERB.new(CassetteRack::Configure.application_template).result(binding)

      [status, headers, [body]]
    end

    private
      def cassettes_tag
        render_branch(tree)
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

      def cassette_tag
        raw = nil
        entry = find_entry(request.path_info)
        unless entry.nil?
          drawer = CassetteRack::Drawer.new
          raw = drawer.create(entry.path)
        end
        raw
      end

      def find_entry(id)
        raw = nil
        tree.each do |entry|
          if entry.id == id
            raw = entry
            break
          end
        end
        raw
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
