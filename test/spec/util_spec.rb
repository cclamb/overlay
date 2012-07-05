require 'rspec'

require_relative '../../lib/util'

describe Util do
  context 'with an overlay logger' do
    it 'should return a logger handle'
    it 'should fail fast if unable to create'
  end
  context 'with a system logger' do
    it 'should return a system logger instance'
    it 'should handle errors on creation clearly'
  end
end