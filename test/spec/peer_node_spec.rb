require 'rspec'

require_relative '../../lib/peer_node'

def create_and_populate_node
  PeerNode.new [ \
    {:id => 'bar',    :artifact => 'foo'}, \
    {:id => 'blech',  :artifact => 'wreck'} \
  ]
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

  it 'should search remotely if nothing is found locally' do
    node = create_and_populate_node
    fail
  end

  it 'should treat a non-existant hop count as a local search'
  it 'should handle a nil ID by returning no results'
  it 'should not fail with badly formatted arguments'
  context 'when used as a primary search node' do
    it 'should search locally only with a zero hop count'
  end
  context 'when used as a secondary search node' do
    it 'should terminate the search when it is the last node in a search chain'
    it 'should increment the hop count on request receipt'
  end
end