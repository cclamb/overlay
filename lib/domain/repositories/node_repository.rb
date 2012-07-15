# This is a node repository class for saving nodes created
# from a YAML description.  We define a node as a hash
# with an associated :id key.
class NodeRepository

  # Initialize the internal storage.
  def initialize
    @nodes = {}
  end

  # Adding a node to the repository.
  def add_node node
    @nodes[node[:id].to_sym] = node
  end

  # Updating a node. This replaces the old node with the
  # new one.
  def update_node node
    @nodes[node[:id].to_sym] = node
  end

  # Deleting a node; we currently set the node to nil
  # in the backing store.
  def delete_node id
    @nodes[id.to_sym] = nil
  end

  # Retriving a node from a submitted ID. The ID can
  # be either a string or a symbol.  Note this returns
  # a copy.  Generally we return value objects that are
  # immutable, but in this case we use a native data
  # structure (a hash) so we return a copy instead.
  def get_node id
    node = @nodes[id.to_sym]
    node == nil ? node : node.clone
  end

end