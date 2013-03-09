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

describe Configuration do

  context 'with a router configuration' do

    before(:all) do
      @cfg = Configuration.new \
        'role' => 'router',
        'context_server' => 'http://some_url',
        'children' => ['1', '2', '3'],
        'parent' => 'some other router',
        'managed' => true
    end

    it 'should indicate it is a router' do
      @cfg.is_router?.should eq true
    end

    it 'should not return peers' do
      @cfg.peers.should eq nil
    end

    it 'should return children' do
      @cfg.children.should_not eq nil
      @cfg.children[1].should eq '2'
    end

    it 'should indicate that it is managed' do
      @cfg.managed?.should eq true
    end

  end

  context 'with a node configuration' do

    before(:all) do
      @cfg = Configuration.new \
        'role' => 'node',
        'parent' => 'parent URL',
        'context_server' => 'ctx server URL',
        'repository' => 'file.dat',
        'managed' => false
      @cfg_no_repo = Configuration.new \
        'role' => 'node',
        'parent' => 'parent URL',
        'context_server' => 'ctx server URL'
    end

    it 'should indicate it is a node' do
      @cfg.is_node?.should eq true
    end

    it 'should indicate it is not managed' do
      @cfg.managed?.should eq false
    end

    it 'should have parent' do
      @cfg.parent.should_not eq nil
    end

    it 'should not have children' do
      @cfg.children.should eq nil
    end

    it 'should have a context server' do
      @cfg.context_server.should eq 'ctx server URL'
    end

    it 'should have a repository and should indicate so' do
      @cfg.has_repository?.should eq true
      @cfg.repository_name.should eq 'file.dat'
    end

    it 'should indicate it does not have a repo if no' do
      @cfg_no_repo.has_repository?.should eq false
      @cfg_no_repo.repository_name.should eq nil
    end

  end

  context 'with a peer node configuration' do

    before(:all) do
      @cfg = Configuration.new \
        'role' => 'peer_node', \
        'peers' => ['1', '2', '3'], \
        'context_server' => 'some context server URL'
    end

    it 'should indicate it is a peer node' do
      @cfg.is_peer_node?.should eq true
    end

    it 'should have peers' do
      @cfg.peers.should_not eq nil
      @cfg.peers[1].should eq '2'
    end

    it 'should not have children' do
      @cfg.children.should eq nil
    end

  end

end