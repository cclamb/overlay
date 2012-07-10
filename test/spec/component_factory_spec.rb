require 'rspec'

require_relative '../../lib/component_factory'

describe ComponentFactory do

    it 'should be creatable' do
      factory = ComponentFactory.new :bucket_name => 'test'
      factory.should_not eq nil
    end

    it 'should fail fast with incorrect parameters' do
      factory = ComponentFactory.new :bucket_name => 'test'
    end
    
    context 'with a LogFactory' do
        it 'should create a system log'
        it 'should create an overlay log'
    end
end