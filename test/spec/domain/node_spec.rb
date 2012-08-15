require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

class TestRepo

  attr_accessor :searched
  attr_accessor :return_nil

  def artifact key
    self.searched = true
    return nil if self.return_nil == true
    'some result'
  end

  def artifacts
    self.searched = true
    return nil if self.return_nil == true
    ['1', '2', '3', '4']
  end

end

class TestUmm

  attr_accessor :executed

  def execute? policy, ctx, activity

  end

end


describe Node do

  it 'should be creatable' do
    Node.new({:repository => Object.new, :umm => Object.new}).should_not eq nil
  end

  it 'should return nil with nil submission' do
    n = Node.new :repository => TestRepo.new, :umm => TestUmm.new
    n.artifact('user', :tablet, nil).should eq nil
  end

  it 'should search the repo with valid arguments' do
    repo = TestRepo.new
    repo.searched = false
    repo.return_nil = true
    n = Node.new :repository => repo, :umm => TestUmm.new
    n.artifact('user', :tablet, 'some_key')
    repo.searched.should eq true
  end

  it 'should search and process results with valid arguments' do
    repo = TestRepo.new
    repo.searched = false
    repo.return_nil = false
    n = Node.new :repository => repo, :umm => TestUmm.new
    result = n.artifact('user', :tablet, 'some_key')
    repo.searched.should eq true
    result.should eq 'some result'
  end

end