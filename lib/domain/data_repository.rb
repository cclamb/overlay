require_relative 'repositories/configuration_repository'

# This is a facade for all repositories to limit coupling
# to specific repository classes.  We use a hierarchy
# of repositories behind this general repository object.
class DataRepository

  # Creating the repository with a hash of arguments emulating
  # a named argument list.  We currently require:
  # * :context_url The URL to the S3 managed context
  def initialize values
    uri = URI::parse values[:context_url]
    @configuration_repository = ConfigurationRepository.new uri
    @node_repository = NodeRepository.new
  end

  # Retrieving the active configuration.
  def get_configuration
    @configuration_repository.get_configuration
  end

  # Adding a node to the repository.
  def add_node node
    @node_repository.add_node node
  end

  # Updating a node.
  def update_node node
    @node_repository.update_node node
  end

  # Deleting a node associated with a given ID. 
  def delete_node id
    @node_repository.delete_node id
  end

  # Retreiving a given node.
  def get_node id
    @node_repository.get_node id
  end

end