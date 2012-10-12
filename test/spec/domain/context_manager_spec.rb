require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe ContextManager do
  it 'should return a context when requested' do
  	ContextManager.new.context[:link].should_not eq nil
  end
end