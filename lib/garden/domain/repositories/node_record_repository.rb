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