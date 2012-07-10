require_relative 'log_factory'

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
class ComponentFactory

  # We initialize the component factory with a hash of
  # values, emulating a named argument list.  Specific
  # required values currently include:
  #
  # * :bucket_name Creates an S3 bucket reference.
  def initialize values
    @log_factory = LogFactory.new values[:bucket_name]
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

end