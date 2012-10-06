require 'rspec'
require 'logging'
require 'socket'
require 'stringio'
require 'uri'
require 'aws-sdk'

require_relative '../../../lib/garden/util'
require_relative '../../../lib/garden/util/s_3'
require_relative '../../../lib/garden/domain'

include Garden

PID_FILE_NAME = '.overlay_pid'
CREDS_FILE_NAME = 'etc/creds.yaml'

def get_creds
  creds = YAML::load File::open(CREDS_FILE_NAME)
  return creds['amazon']['access_key'], creds['amazon']['secret_key']
end

describe Util do

  before(:all) do
    $is_router_called = false
    $is_node_called = false
    $is_peer_node_called = false
    $is_context_server_called = false

    Domain::ComponentFactory::instance :bucket_name => 'foo'
    
    module Util
      def Util::run_as_router *args
        $is_router_called = true
      end

      def Util::run_as_node cfg
        $is_node_called = true
      end

      def Util::run_as_peer_node
        $is_peer_node_called = true
      end

      def Util::run_as_context_server
        $is_context_server_called = true
      end
    end
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

  context 'with a pid file' do

    before(:each) do
      File::write PID_FILE_NAME, '1234567786'
    end

    after(:each) do
      File::delete PID_FILE_NAME if File::exists? PID_FILE_NAME
    end

    it 'should be able to stop a running process and clear the pid file' do
      Util::stop_running_process
      File.exists?(PID_FILE_NAME).should_not eq true
    end

    it 'should not fail if the pid file does not exist' do
      File::delete PID_FILE_NAME
      Util::stop_running_process
      File.exists?(PID_FILE_NAME).should_not eq true
    end

    it 'should save the pid to the pid file' do
      Util::save_pid
      File::exists?(PID_FILE_NAME).should eq true
      pid = File::read(PID_FILE_NAME).to_i
      pid.should eq Process::pid
    end

  end

  context 'with a configuration' do

    it 'should start a node' do
      cfg = Domain::Configuration.new 'role' => 'node'
      cfg.is_node?.should eq true
      Util::start cfg
      $is_node_called.should eq true
      $is_node_called = false
    end

    it 'should start a peer node' do
      cfg = Domain::Configuration.new 'role' => 'peer_node'
      cfg.is_peer_node?.should eq true
      Util::start cfg
      $is_peer_node_called.should eq true
      $is_peer_node_called = false
    end

    it 'should start a context server' do
      cfg = Domain::Configuration.new 'role' => 'context_manager'
      cfg.is_context_server?.should eq true
      Util::start cfg
      $is_context_server_called.should eq true
      $is_context_server_called = false
    end

    it 'should start a router' do
      cfg = Domain::Configuration.new 'role' => 'router'
      cfg.is_router?.should eq true
      Util::start cfg
      $is_router_called.should eq true
      $is_router_called = false
    end

    it 'should read from a submitted URI' do
      s3 = AWS::S3.new
      url = s3.buckets[:chrislambistan_configuration] \
        .objects[:current] \
        .url_for :read
      uri = URI::parse url.to_s
      response = Util::read_object_from_s3 uri
      response.code.should eq '200'
    end

  end

end