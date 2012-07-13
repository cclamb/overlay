require_relative '../../lib/repositories/node_repository'

describe NodeRepository do

  def create_test_node id
    { :id => id, :value => 'value' }
  end

  def create_and_add_node id
    nr = NodeRepository.new
    node = create_test_node id
    nr.add_node node
    return nr
  end

  it 'should be creatable' do
    NodeRepository.new.should_not eq nil
  end

  it 'should save a node' do
  	nr = NodeRepository.new
    nr.add_node create_test_node('foo')
  end

  it 'should retrieve a node' do
    nr = create_and_add_node 'foo'
    nr.get_node('foo')[:id].should eq 'foo'
  end

  it 'should delete a node' do
    nr = create_and_add_node 'bar'
    nr.get_node('bar')[:id].should eq 'bar'
    nr.delete_node 'bar'
    nr.get_node('bar').should eq nil
  end

  it 'should update a node' do
    nr = create_and_add_node 'blech'
    node = nr.get_node 'blech'
    node[:id].should eq 'blech'
    node[:value] = 'new value'
    nr.update_node node
    new_node = nr.get_node('blech')
    node[:id].should eq 'blech'
    node[:value].should eq 'new value'
  end

  it 'should return nil on no node' do
    nr = create_and_add_node 'fleck'
    node = nr.get_node 'macaroni'
    node.should eq nil
  end

  it 'should return a copy of a node' do
    nr = create_and_add_node 'blech'
    node = nr.get_node 'blech'
    node[:id].should eq 'blech'
    node[:value] = 'new value'
    new_node = nr.get_node 'blech'
    new_node[:value].should_not eq 'new value'
  end

end