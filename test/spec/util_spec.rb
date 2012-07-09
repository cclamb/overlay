require 'rspec'
require 'logging'
require 'socket'

require_relative '../../lib/util'
require_relative '../../lib/s_3'

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