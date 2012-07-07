require 'rspec'

require_relative '../../lib/util'

describe Util do
  
  context 'with an overlay logger' do

    it 'should return a logger handle' do
      hndl = Util::overlay_logger self
      hndl.should_not eq nil
    end

  end

  context 'with a system logger' do

    it 'should return a system logger instance' do
      hndl = Util::system_logger self
      hndl.should_not eq nil
    end
    
  end

end