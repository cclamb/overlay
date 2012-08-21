require_relative 'factories'
require_relative 'usage_manager'
require_relative '../../../etc/settings'
require_relative '../util'

include Garden::Domain::Factories

# This is the primary factory facade for components.  We
# use a hierarchy of factories to create objects intended
# to be used behind a specfic interface.  Objects that will
# not change, that we aren't sensitive to strong coupling
# with, can be used with direct instantiation.  Other objects,
# ones that can have multiple instantiations where we want to
# specifically avoid coupling to a specific version, should
# be created by a specic factory.
#
# We maintain a hierarchy of factories all accessed through
# this facade class to limit coupling to specific factories
# as well.
class Garden::Domain::ComponentFactory

  # Initializing the class variable holding the instance.
  @@myself = nil

  # We initialize the component factory with a hash of
  # values, emulating a named argument list.  Specific
  # required values currently include:
  # * :bucket_name Creates an S3 bucket reference.
  def initialize values
    @log_factory = LogFactory.new values[:bucket_name]
    @node_record_factory = NodeRecordFactory.new
  end

  # Creating and returning an instance of the class.
  # We only need to initialize the various factories once.
  # * values  Any needed initialization information.
  def self::instance values = { :bucket_name => 'chrislambistan_log' }
    @@myself = new(values) if @@myself == nil
    @@myself
  end

  # Creating a system log with a specific requestor
  # so we can track entries into the log more easily.
  def create_system_log requestor
    @log_factory.create_system_log requestor
  end

  # Creating an overlay log with a given requestor
  # so S3 entries have correct attribution.
  def create_overlay_log requestor
    @log_factory.create_overlay_log requestor
  end

  # Using a precreated node factory, create a node
  # from a hash of values.
  def create_node_record values
    @node_record_factory.create_node_record values
  end

  # Creating a router from a list of child nodes.
  def create_router children
    Domain::Router.new \
      :umm => create_usage_manager, \
      :dispatcher => create_dispatcher(children), \
      :rectifier => nil
  end

  # Creating a dispatcher, generally for a router.
  def create_dispatcher children
    Domain::Dispatcher.new children, Settings::PORT_NUMBER
  end

  def create_node parent, repo_uri = nil
    Domain::Node.new \
      :dispatcher => create_dispatcher([parent]), \
      :umm => create_usage_manager, \
      :repository => create_artifact_repo(repo_uri)
  end

  # Using a precreated route factory, create a route from
  # a yaml serialization.
  def create_route

  end

  # Create a usage manager.
  def create_usage_manager
    Object.new
  end

  # Creating an artifact repository.
  def create_artifact_repo uri
    return ArtifactRepository::new if uri == nil
    response = Util::read_object_from_s3 uri
    raw_repo = Marshal::load response.body
    ArtifactRepository::new raw_repo
  end

  # def get_uri_for_repo repo_uri
  #   return nil if repo_name == nil
  #   # s3 = AWS::S3.new
  #   # url = s3.buckets[:chrislambistan_repos] \
  #   #   .objects[repo_name] \
  #   #   .url_for :read
  #   url == nil ? url : URI::parse(url.to_s)
  # end

end