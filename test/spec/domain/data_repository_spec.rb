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

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe DataRepository do

  it 'should be creatable' do
    repo = DataRepository::instance :context_url => 'http://bit.ly/x'
    repo.should_not eq nil
    DataRepository::instance.should_not eq nil
  end

  context 'with a configuration factory' do

    it 'should return a valid configuration when needed' do
      url = 'https://s3.amazonaws.com/chrislambistan_configuration/current?AWSAccessKeyId=AKIAISEWSKLPOO37DVVQ&Expires=1339852918&Signature=CRKBIsQ4Gie7TacV9FVtx6xeQts%3D'
      repo = DataRepository::instance :context_url => url
      repo.should_not eq nil
    end

  end

  context 'with a node factory' do

    def create_test_node id
      { :id => id, :value => 'value' }
    end

    def create_and_add_node id
      nr = DataRepository::instance :context_url => 'http://bit.ly/x'
      node = create_test_node id
      nr.add_node_record node
      return nr
    end

    it 'should save a node' do
      nr = DataRepository::instance :context_url => 'http://bit.ly/x'
      nr.add_node_record create_test_node('foo')
    end

    it 'should retrieve a node' do
      nr = create_and_add_node 'foo'
      nr.get_node_record('foo')[:id].should eq 'foo'
    end

    it 'should delete a node' do
      nr = create_and_add_node 'bar'
      nr.get_node_record('bar')[:id].should eq 'bar'
      nr.delete_node_record 'bar'
      nr.get_node_record('bar').should eq nil
    end

    it 'should update a node' do
      nr = create_and_add_node 'blech'
      node = nr.get_node_record 'blech'
      node[:id].should eq 'blech'
      node[:value] = 'new value'
      nr.update_node_record node
      new_node = nr.get_node_record('blech')
      node[:id].should eq 'blech'
      node[:value].should eq 'new value'
    end

    it 'should return nil on no node' do
      nr = create_and_add_node 'fleck'
      node = nr.get_node_record 'macaroni'
      node.should eq nil
    end

    it 'should return a copy of a node' do
      nr = create_and_add_node 'blech'
      node = nr.get_node_record 'blech'
      node[:id].should eq 'blech'
      node[:value] = 'new value'
      new_node = nr.get_node_record 'blech'
      new_node[:value].should_not eq 'new value'
    end

  end

end