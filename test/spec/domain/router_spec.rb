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

  attr_reader :dispatched

  def dispatch request

  end

end

class TestUmm

  def execute? policy, ctx, activity

  end

end

describe Router do

  it 'should be creatable with an optional context manager and required repo' do
    Router.new( \
      :repository => TestRepo.new, \
      :dispatcher => TestDispatcher.new, \
      :umm => TestUmm.new \
    ).should_not eq nil
    Router.new( \
      :repository => TestRepo.new, \
      :dispatcher => TestDispatcher.new, \
      :umm => TestUmm.new,
      :context_factory => TestCtxFactory.new \
    ).should_not eq nil
  end

  it 'should raise an exception with incorred arguments' do
    ->() { Router.new() }.should raise_error
  end

  it 'should route queries to registered nodes' do
    router = Router.new( \
      :repository => TestRepo.new, \
      :dispatcher => TestDispatcher.new, \
      :umm => TestUmm.new \
    )
  end

  it 'should handle data redaction based on context'
end