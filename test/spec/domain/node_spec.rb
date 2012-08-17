require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

module NodeTest

  class Repository

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

  class UsageManager

    attr_accessor :executed

    def execute? policy, ctx, activity

    end

  end

end


describe Node do

  it 'should be creatable' do
    Node.new({:repository => Object.new, :umm => Object.new}).should_not eq nil
  end

  it 'should return nil with nil submission' do
    n = Node.new :repository => NodeTest::Repository.new, :umm => NodeTest::UsageManager.new
    n.artifact('user', :tablet, nil).should eq nil
  end

  it 'should return nil with a nil repo' do
    n = Node.new :repository => nil, :umm => NodeTest::UsageManager.new
    n.artifact('user', :tablet, '123').should eq nil
  end

  it 'should search the repo with valid arguments' do
    repo = NodeTest::Repository.new
    repo.searched = false
    repo.return_nil = true
    n = Node.new :repository => repo, :umm => NodeTest::UsageManager.new
    n.artifact('user', :tablet, 'some_key')
    repo.searched.should eq true
  end

  it 'should search and process results with valid arguments' do
    repo = NodeTest::Repository.new
    repo.searched = false
    repo.return_nil = false
    n = Node.new :repository => repo, :umm => NodeTest::UsageManager.new
    result = n.artifact('user', :tablet, 'some_key')
    repo.searched.should eq true
    result.should eq 'some result'
  end

end