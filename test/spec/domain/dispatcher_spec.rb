require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe Dispatcher do

  before(:all) do
    Domain::ComponentFactory::instance :bucket_name => 'foo'
  end

  it 'should be creatable' do
    d = Dispatcher.new [], 4567, 'name'
  end

end