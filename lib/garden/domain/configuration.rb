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
# this is a simple class to wrap and serve configuration information
# for a given session when downloaded from the S3 configuration bucket.
class Garden::Domain::Configuration

  def initialize ctx_map
    @ctx_map = ctx_map || {}
  end

  def name
    @ctx_map['name']
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

  def is_context_server?
    @ctx_map['role'] == 'context_manager'
  end

  def has_peers?
    @ctx_map['peers'] != nil
  end

  def has_router?
    @ctx_map['router'] != nil
  end

  def has_confidentiality_strategy?
    @ctx_map['confidentiality_strategy'] != nil
  end

  def managed?
    @ctx_map['managed'] != nil && (@ctx_map['managed'] == true || @ctx_map['managed'] == 'true')
  end

  def confidentiality_strategy
    @ctx_map['confidentiality_strategy'] != nil ? @ctx_map['confidentiality_strategy'].to_sym : nil
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

  def has_repository?
    @ctx_map['repository'] != nil
  end

  def repository_name
    @ctx_map['repository']
  end

end