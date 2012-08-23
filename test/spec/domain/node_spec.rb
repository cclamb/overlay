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
      self.executed = true
    end
  end

  class Dispatcher
    attr_accessor :executed
    def dispatch_artifacts *args 
      self.executed = true
      'boofar'
    end
    def dispatch_artifact *args
      self.executed = true
      ['1','2','3']
    end
  end

end


describe Node do

  after(:all) do
    File.delete 'system.log' if File.exists? 'system.log'
  end

  it 'should be creatable' do
    Node.new({:repository => Object.new, :umm => Object.new, :dispatcher => Object.new}).should_not eq nil
  end

  it 'should return nil with nil submission' do
    n = Node.new \
      :dispatcher => NodeTest::Dispatcher.new, \
      :repository => NodeTest::Repository.new, \
      :umm => NodeTest::UsageManager.new
    n.artifact('user', :tablet, nil).should eq nil
  end

  it 'should return nil with a nil repo' do
    n = Node.new \
      :dispatcher => NodeTest::Dispatcher.new, \
      :repository => nil, \
      :umm => NodeTest::UsageManager.new
    n.artifact('user', :tablet, '123').should eq nil
  end

  it 'should search for artifacts with default arguments' do
    repo = NodeTest::Repository.new
    repo.searched = false
    repo.return_nil = true
    dispatcher = NodeTest::Dispatcher.new
    dispatcher.executed = false
    n = Node.new \
      :dispatcher => dispatcher, \
      :repository => repo, \
      :umm => NodeTest::UsageManager.new
    n.artifacts 'user', :tablet
    repo.searched.should eq true
    dispatcher.executed.should eq true
  end

  it 'should search for artifacts with valid arguments' do
    repo = NodeTest::Repository.new
    repo.searched = false
    repo.return_nil = true
    dispatcher = NodeTest::Dispatcher.new
    dispatcher.executed = false
    n = Node.new :repository => repo, :dispatcher => dispatcher, :umm => NodeTest::UsageManager.new
    n.artifacts 'user', :tablet, :standalone
    repo.searched.should eq true
    dispatcher.executed.should eq false
  end

  it 'should search the repo with default arguments' do
    repo = NodeTest::Repository.new
    repo.searched = false
    repo.return_nil = true
    dispatcher = NodeTest::Dispatcher.new
    dispatcher.executed = false
    n = Node.new :repository => repo, :dispatcher => dispatcher, :umm => NodeTest::UsageManager.new
    n.artifact 'user', :tablet, 'some_key'
    repo.searched.should eq true
    dispatcher.executed.should eq true
  end

  it 'should search and process results with default arguments' do
    repo = NodeTest::Repository.new
    repo.searched = false
    repo.return_nil = false
    dispatcher = NodeTest::Dispatcher.new
    dispatcher.executed = false
    n = Node.new :repository => repo, :dispatcher => dispatcher, :umm => NodeTest::UsageManager.new
    result = n.artifact 'user', :tablet, 'some_key'
    repo.searched.should eq true
    result.should eq 'some result'
    dispatcher.executed.should eq false
  end

  it 'should search the repo with valid arguments' do
    repo = NodeTest::Repository.new
    repo.searched = false
    repo.return_nil = true
    dispatcher = NodeTest::Dispatcher.new
    dispatcher.executed = false
    n = Node.new :repository => repo, :dispatcher => dispatcher, :umm => NodeTest::UsageManager.new
    n.artifact 'user', :tablet, 'some_key', :standalone
    repo.searched.should eq true
    dispatcher.executed.should eq false
  end

  it 'should search and process results with valid arguments' do
    repo = NodeTest::Repository.new
    repo.searched = false
    repo.return_nil = false
    dispatcher = NodeTest::Dispatcher.new
    dispatcher.executed = false
    n = Node.new :repository => repo, :dispatcher => dispatcher, :umm => NodeTest::UsageManager.new
    result = n.artifact 'user', :tablet, 'some_key', :standalone
    repo.searched.should eq true
    result.should eq 'some result'
    dispatcher.executed.should eq false
  end

end