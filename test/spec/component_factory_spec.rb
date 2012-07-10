require 'rspec'

require_relative '../../lib/component_factory'

describe ComponentFactory do
    it 'should be creatable'
    it 'should fail fast with incorrect parameters'
    context 'with a LogFactory' do
        it 'should create a system log'
        it 'should create an overlay log'
    end
end