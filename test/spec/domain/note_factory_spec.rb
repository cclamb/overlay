require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe NodeFactory do

  it 'should be creatable' do
    NodeFactory.new.should_not eq nil
  end

  it 'should create a node from a yaml element' do
    nf = NodeFactory.new
    yaml_values = { 'hostname' => 1, \
      'test_0' => 0, \
      'test_1' => 1, \
      'test_2' => 2 }
    node = nf.create_node yaml_values
    node[:id].should eq 1
    node[:test_0].should eq 0
    node[:test_1].should eq 1
    node[:test_2].should eq 2
  end

end