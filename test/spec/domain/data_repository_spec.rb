require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe DataRepository do

  it 'should be creatable' do
    repo = DataRepository.new :context_url => 'http://bit.ly/x'
    repo.should_not eq nil
  end

  it 'should fail-fast with bad parameters' do
    expect { DataRepository.new }.to raise_error
    expect { DataRepository.new :context_url => nil }.to raise_error
  end

  context 'with a configuration factory' do

    it 'should return a valid configuration when needed' do
      url = 'https://s3.amazonaws.com/chrislambistan_configuration/current?AWSAccessKeyId=AKIAISEWSKLPOO37DVVQ&Expires=1339852918&Signature=CRKBIsQ4Gie7TacV9FVtx6xeQts%3D'
      repo = DataRepository.new :context_url => url
      repo.should_not eq nil
    end

  end

  context 'with a node factory' do

    def create_test_node id
      { :id => id, :value => 'value' }
    end

    def create_and_add_node id
      nr = DataRepository.new :context_url => 'http://bit.ly/x'
      node = create_test_node id
      nr.add_node node
      return nr
    end

    it 'should save a node' do
      nr = DataRepository.new :context_url => 'http://bit.ly/x'
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

end