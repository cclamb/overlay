require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe Configuration do

  context 'with a router configuration' do

    before(:all) do
      @cfg = Configuration.new \
        'role' => 'router', \
        'context_server' => 'http://some_url', \
        'children' => ['1', '2', '3'], \
        'parent' => 'some other router'
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

  end

  context 'with a node configuration' do

    before(:all) do
      @cfg = Configuration.new \
        'role' => 'node', \
        'parent' => 'parent URL', \
        'context_server' => 'ctx server URL'
    end

    it 'should indicate it is a node' do
      @cfg.is_node?.should eq true
    end

    it 'should have parent' do
      @cfg.parent.should_not eq nil
    end

    it 'shoud not have children' do
      @cfg.children.should eq nil
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