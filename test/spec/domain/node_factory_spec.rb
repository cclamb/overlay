require 'rspec'

require_relative '../../../lib/garden/domain/factories'

include Garden::Domain::Factories

describe NodeFactory do

  it 'should be creatable' do
  	NodeFactory.new.should_not eq nil
  end

  it 'should create a node' do
  	NodeFactory.new.create_node({:umm => Object.new, :repository => Object.new}).should_not eq nil
  end

end