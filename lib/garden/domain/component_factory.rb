#--
# Copyright (c) 2012 Christopher C. Lamb
#
# SBIR DATA RIGHTS
# Contract No. FA8750-11-C-0195
# Contractor: AHS Engineering Services (under subcontract to Modus Operandi, Inc.)
# Address: 5909 Canyon Creek Drive NE, Albuquerque, NM 87111
# Expiration Date: 05/03/2018
# 
# The Government’s rights to use, modify, reproduce, release, perform, display, 
# or disclose technical data or computer software marked with this legend are 
# restricted during the period shown as provided in paragraph (b) (4) 
# of the Rights in Noncommercial Technical Data and Computer Software-Small 
# Business Innovative Research (SBIR) Program clause contained in the above 
# identified contract. No restrictions apply after the expiration date shown 
# above. Any reproduction of technical data, computer software, or portions 
# thereof marked with this legend must also reproduce the markings.
#++
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
  def create_router args # children, parent = nil, name = nil
    Domain::Router.new \
      :dispatcher => create_dispatcher(args[:children], args[:name]),
      :context_manager => Domain::ContextManager.new,
      :parent_dispatcher => args[:parent] == nil ? nil : create_dispatcher([args[:parent]], args[:name]),
      :rectifier => create_rectifier(:confidentiality_strategy => args[:confidentiality_strategy], \
        :managed => args[:managed])
  end

  # Creating a dispatcher, generally for a router.
  def create_dispatcher children, name
    Domain::Dispatcher.new children, Settings::PORT_NUMBER, name
  end

  def create_node args #parent, repo_uri = nil, name = nil
    Domain::Node.new \
      :dispatcher => create_dispatcher([args[:parent]], args[:name]),
      :repository => create_artifact_repo(args[:repo_uri]),
      :context_manager => Domain::ContextManager.new,
      :rectifier => create_rectifier(:confidentiality_strategy => args[:confidentiality_strategy], \
        :managed => args[:managed])
  end

  # Using a precreated route factory, create a route from
  # a yaml serialization.
  def create_route

  end

  # Create a usage manager.
  def create_rectifier args = { :confidentiality_strategy => :redact}
    if args[:managed] == true
      Util::ContentRectifier.new \
        :umm => Domain::UsageManagementMechanism.new,
        :confidentiality_strategy => args[:confidentiality_strategy]
    else
      Util::NilContentRectifier.new
    end
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