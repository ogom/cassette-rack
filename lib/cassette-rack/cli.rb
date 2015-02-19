module CassetteRack
  module Cli
    class << self
      def draw(dest_path)
        tree = CassetteRack::Tree.create(CassetteRack::Configure.source_path)
        tree.each do |entry|
          if entry.leaf?
            drawer = CassetteRack::Drawer.new(entry.id)
            if drawer.exist?
              path = File.join(dest_path, entry.id)
              File.open(path + '.md', 'w') do |file|
                file.puts drawer.pull
              end
            end
          else
            path = File.join(dest_path, entry.id)
            FileUtils.mkdir_p(path)
          end
        end
      end
    end
  end
end
