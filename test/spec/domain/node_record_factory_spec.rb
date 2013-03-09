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
require 'rspec'

require_relative '../../../lib/garden/domain/factories'

include Garden::Domain::Factories

describe NodeRecordFactory do

  it 'should be creatable' do
    NodeRecordFactory.new.should_not eq nil
  end

  it 'should create a node from a yaml element' do
    nf = NodeRecordFactory.new
    yaml_values = { 'hostname' => 1, \
      'test_0' => 0, \
      'test_1' => 1, \
      'test_2' => 2 }
    node = nf.create_node_record yaml_values
    node[:id].should eq 1
    node[:test_0].should eq 0
    node[:test_1].should eq 1
    node[:test_2].should eq 2
  end

end