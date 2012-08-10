require 'rspec'

require_relative '../../../lib/garden/domain/factories'

include Garden::Domain::Factories

describe UmmFactory do
  it 'should be creatable' do
  	UmmFactory.new.should_not eq nil
  end

  it 'should create a usage management mechanism' do
  	UmmFactory.new.create_umm.should_not eq nil
  end
end