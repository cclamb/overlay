# this is a simple class to wrap and serve configuration information
# for a given session when downloaded from the S3 configuration bucket.
class Garden::Domain::Configuration

  def initialize ctx_map
    @ctx_map = ctx_map
  end

  def is_router?
    @ctx_map['role'] == 'router'
  end

  def is_node?
    @ctx_map['role'] == 'node'
  end

  def is_peer_node?
    @ctx_map['role'] == 'peer_node'
  end

  def has_peers?
    @ctx_map['peers'] != nil
  end

  def has_router?
    @ctx_map['router'] != nil
  end

  def peers
    @ctx_map['peers']
  end

  def has_parent?
    @ctx_map['parent'] != nil
  end

  def parent
    @ctx_map['parent']
  end

  def has_children
    @ctx_map['children'] != nil
  end

  def children
    @ctx_map['children']
  end

  def context_server
    @ctx_map['context_manager']
  end

end