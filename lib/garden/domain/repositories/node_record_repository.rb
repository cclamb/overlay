# This is a node repository class for saving nodes created
# from a YAML description.  We define a node as a hash
# with an associated :id key.
class NodeRecordRepository

  # Initialize the internal storage.
  def initialize
    @node_records = {}
  end

  # Adding a node to the repository.
  def add_node_record node_record
    @node_records[node_record[:id].to_sym] = node_record
  end

  # Updating a node. This replaces the old node with the
  # new one.
  def update_node_record node_record
    @node_records[node_record[:id].to_sym] = node_record
  end

  # Deleting a node; we currently set the node to nil
  # in the backing store.
  def delete_node_record id
    @node_records[id.to_sym] = nil
  end

  # Retriving a node from a submitted ID. The ID can
  # be either a string or a symbol.  Note this returns
  # a copy.  Generally we return value objects that are
  # immutable, but in this case we use a native data
  # structure (a hash) so we return a copy instead.
  def get_node_record id
    node_record = @node_records[id.to_sym]
    node_record == nil ? node_record : node_record.clone
  end

end