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
require 'socket'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::PeerNodeService < TestInterface
  enable :inline_templates

  @@factory =nil

  def self::set_test_params params
    @@factory = params[:factory]
  end

  def self::create_factory
    @@factory || ComponentFactory.new(:bucket_name => 'test')
  end

  get '/artifact/:id' do
    id = params[:id]
    halt 404
  end

end