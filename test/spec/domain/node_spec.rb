#--
# Copyright (c) 2012 Christopher C. Lamb
#
# SBIR DATA RIGHTS
# Contract No. FA8750-11-C-0195
# Contractor: AHS Engineering Services (under subcontract to Modus Operandi, Inc.)
# Address: 5909 Canyon Creek Drive NE, Albuquerque, NM 87111
# Expiration Date: 05/03/2018
# 
# The Government’s rights to use, modify, reproduce, release, perform, display, 
# or disclose technical data or computer software marked with this legend are 
# restricted during the period shown as provided in paragraph (b) (4) 
# of the Rights in Noncommercial Technical Data and Computer Software-Small 
# Business Innovative Research (SBIR) Program clause contained in the above 
# identified contract. No restrictions apply after the expiration date shown 
# above. Any reproduction of technical data, computer software, or portions 
# thereof marked with this legend must also reproduce the markings.
#++
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

  class ContentRectifier
    def process args
      args[:artifact]
    end
  end

  class ContextManager
    def context ip_addr
      {
        :link => {},
        :user => {}
      }
    end
  end

end


describe Node do

  after(:all) do
    File.delete 'system.log' if File.exists? 'system.log'
  end

  it 'should be creatable' do
    Node.new({:repository => Object.new, :rectifier => Object.new, :dispatcher => Object.new}).should_not eq nil
  end

  it 'should return nil with nil submission' do
    n = Node.new \
      :dispatcher => NodeTest::Dispatcher.new,
      :repository => NodeTest::Repository.new,
      :rectifier => NodeTest::ContentRectifier.new,
      :context_manager => NodeTest::ContextManager.new
    n.artifact('user', :tablet, nil).should eq nil
  end

  it 'should return nil with a nil repo' do
    n = Node.new \
      :dispatcher => NodeTest::Dispatcher.new,
      :repository => nil, 
      :rectifier => NodeTest::ContentRectifier.new,
      :context_manager => NodeTest::ContextManager.new
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
      :rectifier => NodeTest::ContentRectifier.new,
      :context_manager => NodeTest::ContextManager.new
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
    n = Node.new :repository => repo, :dispatcher => dispatcher, :rectifier => NodeTest::ContentRectifier.new,
      :context_manager => NodeTest::ContextManager.new
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
    n = Node.new :repository => repo, :dispatcher => dispatcher, :rectifier => NodeTest::ContentRectifier.new,
      :context_manager => NodeTest::ContextManager.new
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
    n = Node.new :repository => repo, :dispatcher => dispatcher, :rectifier => NodeTest::ContentRectifier.new,
      :context_manager => NodeTest::ContextManager.new
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
    n = Node.new :repository => repo, :dispatcher => dispatcher, :rectifier => NodeTest::ContentRectifier.new,
      :context_manager => NodeTest::ContextManager.new
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
    n = Node.new :repository => repo, :dispatcher => dispatcher, :rectifier => NodeTest::ContentRectifier.new,
      :context_manager => NodeTest::ContextManager.new
    result = n.artifact 'user', :tablet, 'some_key', :standalone
    repo.searched.should eq true
    result.should eq 'some result'
    dispatcher.executed.should eq false
  end

end