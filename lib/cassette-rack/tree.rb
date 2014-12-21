require_relative 'tree/leaf'
require_relative 'tree/branch'

module CassetteRack
  module Tree
    def self.create(path)
      CassetteRack::Tree::Branch.new(path)
    end
  end
end
