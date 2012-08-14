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

  def dispatch *args
    self.dispatched = true
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

  it 'should route queries when called for a specific artifact'
  it 'should handle data redaction based on context'
end