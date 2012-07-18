require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe Router do
  it 'should be creatable'
  it 'should route queries to registered nodes'
  it 'should handle data redaction based on context'
end