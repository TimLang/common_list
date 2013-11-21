
require 'debugger'

module CommonList

  class TreeLike
    attr_accessor :id, :name, :code, :value, :child, :depth

    def initialize block
      @child = []
      block.call(self)
    end

    def << lamba
      @child << self.class.new(lamba)
      self
    end

    include Enumerable

    def each(&block)
      block.call(self)
      @child.map{|c| c.each(&block)}
    end

    def to_s
      @code
    end

    class << self
      def walk tree, &block
        unless tree.child.empty?
          block.call(tree)
          tree.child.each{|c| walk(c, &block)}
        else
          block.call(tree)
        end
      end
    end

  end

end
