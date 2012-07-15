class NodeFactory

  def create_node values
    node = {}
    values.each_key { |key| node[key.to_sym] = values[key] }
    node[:id] = node[:hostname]
    node
  end

end