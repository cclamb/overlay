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

class TestRepo

  def artifact key

  end
  def artifacts

  end

end

class TestCtxFactory

  def assemble_context subject, resource, device

  end

end

class TestDispatcher

  attr_accessor :dispatched

  def dispatch_artifacts *args
    self.dispatched = true
    []
  end

  def dispatch_artifact *args
    self.dispatched = true
    []
  end

end

class TestUmm

  def execute? policy, ctx, activity

  end

end

class TestRectifier

  def partition artifact_descriptor

  end

  def assemble bundles

  end

end

describe Router do

  it 'should be creatable with an optional context manager and required repo' do
    Router.new( \
      :repository => TestRepo.new, \
      :dispatcher => TestDispatcher.new, \
      :umm => TestUmm.new, \
      :rectifier => TestRectifier.new, \
    ).should_not eq nil
    Router.new( \
      :repository => TestRepo.new, \
      :dispatcher => TestDispatcher.new, \
      :umm => TestUmm.new,
      :context_factory => TestCtxFactory.new, \
      :rectifier => TestRectifier.new \
    ).should_not eq nil
  end

  it 'should raise an exception with incorred arguments' do
    ->() { Router.new() }.should raise_error
  end

  it 'should route queries to registered nodes when called for artifacts' do
    dispatcher = TestDispatcher.new
    dispatcher.dispatched = false
    router = Router.new \
      :repository => TestRepo.new, \
      :dispatcher => dispatcher, \
      :rectifier => TestRectifier.new, \
      :umm => TestUmm.new
    router.artifacts 'foobar', :iphone
    dispatcher.dispatched.should eq true
  end

  it 'should route queries when called for a specific artifact' do
    dispatcher = TestDispatcher.new
    dispatcher.dispatched = false
    router = Router.new \
      :repository => TestRepo.new, \
      :dispatcher => dispatcher, \
      :rectifier => TestRectifier.new, \
      :umm => TestUmm.new
    router.artifact 'foobar', :iphone, 'key'
    dispatcher.dispatched.should eq true
  end

end