require_relative 'repositories'

include Garden::Domain::Repositories

# This is a facade for all repositories to limit coupling
# to specific repository classes.  We use a hierarchy
# of repositories behind this general repository object.
class Garden::Domain::DataRepository

  # Initializing the class variable holding the instance.
  @@myself = nil

  # Creating the repository with a hash of arguments emulating
  # a named argument list.  We currently require:
  # * :context_url The URL to the S3 managed context
  def initialize values
    uri = URI::parse values[:context_url]
    @configuration_repository = ConfigurationRepository.new uri
    @node_record_repository = NodeRecordRepository.new
  end

  # Creating and returning an instance of the class.
  # We only need to initialize the various factories once.
  # * values  Any needed initialization information.
  def self::instance values = nil
    @@myself = new(values) if @@myself == nil
    @@myself
  end

  # Retrieving the active configuration.
  def get_configuration
    @configuration_repository.get_configuration
  end

  # Adding a node to the repository.
  def add_node_record node_record
    @node_record_repository.add_node_record node_record
  end

  # Updating a node.
  def update_node_record node_record
    @node_record_repository.update_node_record node_record
  end

  # Deleting a node associated with a given ID. 
  def delete_node_record id
    @node_record_repository.delete_node_record id
  end

  # Retreiving a given node.
  def get_node_record id
    @node_record_repository.get_node_record id
  end

end