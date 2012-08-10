require_relative '../node'

include Garden

class NodeFactory
  def create_node params
    Domain::Node.new :umm => params[:umm], :repository => params[:repository]
  end
end