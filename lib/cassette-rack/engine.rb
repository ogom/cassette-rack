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
      def index_tag
        render_branch(tree)
      end

      def render_branch(node)
        raw = ''
        raw += "<div style=\"padding-left: #{node.level}0px;\">\n"
        raw += "<h3 onclick=\"check_branch('#{node.id}')\" >#{node.name}</h3>\n"
        raw += "<div id=#{node.id}>\n"
        arr = []
        node.entries.each do |entry|
          if entry.leaf?
            arr << entry
          else
            raw += render_branch(entry)
          end
        end
        raw += "<ul>" + arr.map do |entry|
          raw = "<li"
          raw += " class='active'"if entry.id == request.path_info
          raw += "><a href=#{request.script_name}#{entry.id}>#{entry.name}</a></li>"
        end.join("\n")
        raw += "</ul></div></div>\n"
        raw
      end

      def show_tag
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
