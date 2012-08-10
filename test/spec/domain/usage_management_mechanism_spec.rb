require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe UsageManagementMechanism do
  it 'should be creatable' do
    UsageManagementMechanism.new.should_not eq nil
  end
end