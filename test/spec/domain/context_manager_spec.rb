require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe ContextManager do
  it 'should be creatable'
  it 'should return nil if the route does not exist'
  it 'should return nil if nil is submitted as the route'
  it 'should return the correct route status'
end