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