# Predefining the Garden namespace to ensure
# it exists prior to application layer class
# inclusion.
module Garden 
  module Application
  end
end

# Application layer class definitions.
require_relative 'application/context_manager_service'
require_relative 'application/node_service'
require_relative 'application/peer_node_service'
require_relative 'application/router_service'