
$: << File.join(File.dirname(__FILE__))
require 'common_list'

class Example
  attr_accessor :visited

  Print_Lambda = lambda do |tree|
    if tree.depth > 0
      puts "  " * tree.depth + "|_" + tree.name + "(#{tree.code})"
    else
      puts "#{tree.name}"
    end
  end

  class << self
    #mock a web page click from user
    def click tree
      @visited ||= []

      compare_lamda = lambda {|a, b| a.code.sub(/(\w+)\d+/, '\1') == b.code.sub(/(\w+)\d+/, '\1')}

      if lambda{|b| @visited.find{|a| compare_lamda.call(a, b)}}.call(tree)
        @visited.delete_if{|v| compare_lamda.call(v, tree)}
        @visited << tree
      else
        @visited << tree
      end
    end


    def get_visited
      @visited.sort_by{|v| v.code}
    end

  end

  def create_tree
    tree = CommonList::TreeLike.new lambda{|t| t.name="gift list"; t.depth=0}
    tree << (lambda{|t| t.name="relation";t.depth=1;t.code='a'}) << lambda{|t| t.name="situation";t.depth=1;t.code='b'}

    relation = tree.find{|node| node.name == 'relation'} 

    relation << lambda {|t| t.name="send parent";t.depth=2;t.code="#{relation.code}1"} << lambda {|t| t.name="send women";t.depth=2;t.code="#{relation.code}2"} << lambda {|t| t.name="send men";t.depth=2;t.code="#{relation.code}3"}

    situation = tree.find{|node| node.name == 'situation'}

    situation << lambda {|t| t.name="birthday";t.depth=2;t.code="#{situation.code}1"} << lambda {|t| t.name="bussiness";t.depth=2;t.code="#{situation.code}2"} << lambda {|t| t.name="meeting";t.depth=2;t.code="#{situation.code}3"}
    tree
  end


end

tree = Example.new.create_tree
CommonList::TreeLike.walk(tree, &Example::Print_Lambda)

Example.click(CommonList::TreeLike.new lambda {|t| t.code='a1';t.name='parent'})
puts "click 'send parent' then /" + Example.get_visited.join('-') + '/'

Example.click(CommonList::TreeLike.new lambda {|t| t.code='b2';t.name='bussiness'})
Example.click(CommonList::TreeLike.new lambda {|t| t.code='a2';t.name='women'})

puts "clicking 'send women' and 'bussiness' then /#{Example.get_visited.join('-')}/"
