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
# The namespace definition for the domain namespace.
# We ensure that Garden is defined prior to including
# any of the domain classes.
module Garden 
  module Application
  end
end

# Domain layer class definitions.
require_relative 'domain/component_factory'
require_relative 'domain/data_repository'
require_relative 'domain/node'
require_relative 'domain/peer_node'
require_relative 'domain/router'
require_relative 'domain/context_manager'
require_relative 'domain/usage_manager'
require_relative 'domain/configuration'
require_relative 'domain/usage_management_mechanism'
require_relative 'domain/dispatcher'
require_relative 'domain/artifact_repository'