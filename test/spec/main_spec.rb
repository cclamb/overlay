require 'rspec'

require_relative '../../lib/main'

describe Main do

  context 'with command line arguments' do
    it 'should process valid command line arguments'
    it 'should handle invalid command line arguments'
  end

  context 'with amazon credentials' do
    it 'should configure with valid credentials'
    it 'should fail with clear message when invalid'
  end

  context 'with logging' do
    it 'should configure logging with S3'
    it 'should configure standard file-based logging'
  end

  context 'with a simiulation context' do
    it 'should load a simulation context'
    it 'should handle poorly formatted contexts'
    it 'should handle a non-existant context'
  end
end