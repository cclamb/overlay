require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe NodeRecordRepository do

  def create_test_node id
    { :id => id, :value => 'value' }
  end

  def create_and_add_node id
    nr = NodeRecordRepository.new
    node = create_test_node id
    nr.add_node_record node
    return nr
  end

  it 'should be creatable' do
    NodeRecordRepository.new.should_not eq nil
  end

  it 'should save a node' do
  	nr = NodeRecordRepository.new
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