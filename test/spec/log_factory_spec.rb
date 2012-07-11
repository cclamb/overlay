require 'rspec'

require_relative '../../lib/log_factory'

LOG_FILE_NAME = 'system.log'

describe LogFactory  do

    after(:all) do
      File.delete LOG_FILE_NAME if File.exists? LOG_FILE_NAME
    end
    
    it 'should be creatable' do
      repo = LogFactory.new 'some bucket name'
      repo.should_not eq nil
    end

    it 'should return a system logger' do
      repo = LogFactory.new 'some bucket name'
      logger = repo.create_system_log self
      logger.should_not eq nil
    end

    it 'should return an overlay logger' do
      repo = LogFactory.new 'some bucket name'
      logger = repo.create_overlay_log self
      logger.should_not eq nil
    end

end