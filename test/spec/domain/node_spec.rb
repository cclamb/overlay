require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe Node do
  it 'should be creatable'
  it 'should return nil with nil submission'
  it 'should return nil if the content does not exist'
  it 'should return content if it has it'
end