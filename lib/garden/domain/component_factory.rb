require_relative 'factories'
require_relative 'usage_manager'

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
  def self::instance values = nil
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

  # Using a precreated route factory, create a route from
  # a yaml serialization.
  def create_route

  end

  # Create a usage manager.
  def create_usage_manager
    UsageManager.new
  end

end