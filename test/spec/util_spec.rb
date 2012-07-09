require 'rspec'
require 'logging'
require 'socket'

require_relative '../../lib/util'
require_relative '../../lib/s_3'

CREDS_FILE_NAME = 'etc/creds.yaml'
LOG_FILE_NAME = 'system.log'

def get_creds
  creds = YAML::load File::open(CREDS_FILE_NAME)
  return creds['amazon']['access_key'], creds['amazon']['secret_key']
end

describe Util do

  before(:all) do
    hostname = Socket.gethostname
    appender = Logging.appenders.s3 \
      :level => :debug, \
      :layout => Logging.layouts.yaml(:format_as => :yaml), \
      :source => Socket::gethostname, \
      :bucket_name => 'bucket'
    file_appender = Logging.appenders.file \
      'system.log', \
      :level => :debug
  end

 context 'with amazon credentials' do

    it 'should configure with valid credentials' do
      access_key, secret_key = get_creds
      args = {:access_key => access_key, :secret_key => secret_key}
      Util::configure_aws args
      cfg = AWS.config
      cfg.access_key_id.should eq access_key
      cfg.secret_access_key.should eq secret_key
    end

    it 'should fail with clear message when nil access' do
      access_key, secret_key = get_creds
      args = {:access_key => nil, :secret_key => secret_key}
      expect { Util::configure_aws args }.to raise_error
    end

    it 'should fail with clear message when nil secret' do
      access_key, secret_key = get_creds
      args = {:access_key => access_key, :secret_key => nil}
      expect { Util::configure_aws args }.to raise_error
    end

  end

  context 'with logging' do

    after(:all) do
      File.delete LOG_FILE_NAME if File.exists? LOG_FILE_NAME
    end

    it 'should configure logging' do
      Util::configure_logging :bucket_name => :bname
      log = Logging.logger[self]
      log.add_appenders 's3'
      log.add_appenders LOG_FILE_NAME
    end

  end

  context 'with command line arguments' do

    it 'should process valid command line arguments' do
      args = Util::process_args [:url, :akey, :skey, :bname]
      args[:context_url].should eq :url
      args[:access_key].should eq :akey
      args[:secret_key].should eq :skey
      args[:bucket_name].should eq :bname
    end

    it 'should handle invalid command line arguments' do
      args = Util::process_args [:url, :akey, :skey]
      args[:context_url].should eq :url
      args[:access_key].should eq :akey
      args[:secret_key].should eq :skey
      args[:bucket_name].should eq nil
    end

  end
  
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