require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

$searched_remote = false

def create_and_populate_node
  PeerNode.new [ \
    {:id => 'bar',    :artifact => 'foo'}, \
    {:id => 'blech',  :artifact => 'wreck'} \
  ]
end

def create_and_populate_node_remote
  PeerNode.new [ \
    {:id => 'bar',    :artifact => 'foo'}, \
    {:id => 'blech',  :artifact => 'wreck'} \
  ] \
  do |id, ctx, r_ctx|
    $searched_remote = true
    []
  end
end

describe PeerNode do

  it 'should be creatable' do
    node = PeerNode.new
    node.should_not eq nil
    node = PeerNode.new []
    node.should_not eq nil
    node = PeerNode.new [ \
      {:id => 'bar',    :artifact => 'foo'}, \
      {:id => 'blech',  :artifact => 'wreck'}\
    ]
    node.should_not eq nil
  end

  it 'should return an empty collection if nothing found' do
    node = create_and_populate_node
    results = node.find_artifact 'not me!'
    results.should_not eq nil
    results.count.should eq 0
  end


  it 'should handle a nil ID by returning no results' do
    node = create_and_populate_node_remote

  end

  #it 'should not fail with badly formatted arguments'
  
  context 'when used as a primary search node' do

    it 'should search remotely if nothing is found locally' do
      node = create_and_populate_node_remote
      results = node.find_artifact 'not me!', {:hop_count => 1}
      $searched_remote.should eq true
      $searched_remote = false
    end

    it 'should not search remotely if the hop_count does not exist' do
      node = create_and_populate_node_remote
      results = node.find_artifact 'not me!'
      $searched_remote.should eq false
    end

    it 'should not search remotely if the hop_count is too low' do
      node = create_and_populate_node_remote
      results = node.find_artifact 'not me!', {:hop_count => 0}
      $searched_remote.should eq false
      results = node.find_artifact 'not me!', {:hop_count => -3}
      $searched_remote.should eq false
    end

    # it 'should treat a non-existant hop count as a local search'
    # it 'should search locally only with a zero hop count'
  end
  # context 'when used as a secondary search node' do
  #   it 'should terminate the search when it is the last node in a search chain'
  #   it 'should increment the hop count on request receipt'
  # end
end