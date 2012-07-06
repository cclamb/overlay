require 'rspec'
require 'aws-sdk'
require 'logging'

require_relative '../../lib/main'

CREDS_FILE_NAME = '../etc/creds.yaml'
LOG_FILE_NAME = 'system.log'

def get_creds
  creds = YAML::load File::open(CREDS_FILE_NAME)
  return creds['amazon']['access_key'], creds['amazon']['secret_key']
end

describe Main do

  context 'with command line arguments' do

    it 'should process valid command line arguments' do
      args = Main::process_args [:url, :akey, :skey, :bname]
      args[:context_url].should eq :url
      args[:access_key].should eq :akey
      args[:secret_key].should eq :skey
      args[:bucket_name].should eq :bname
    end

    it 'should handle invalid command line arguments' do
      args = Main::process_args [:url, :akey, :skey]
      args[:context_url].should eq :url
      args[:access_key].should eq :akey
      args[:secret_key].should eq :skey
      args[:bucket_name].should eq nil
    end

  end

  context 'with amazon credentials' do

    it 'should configure with valid credentials' do
      access_key, secret_key = get_creds
      args = {:access_key => access_key, :secret_key => secret_key}
      Main::configure_aws args
      cfg = AWS.config
      cfg.access_key_id.should eq access_key
      cfg.secret_access_key.should eq secret_key
    end

    it 'should fail with clear message when nil access' do
      access_key, secret_key = get_creds
      args = {:access_key => nil, :secret_key => secret_key}
      expect { Main::configure_aws args }.to raise_error
    end

    it 'should fail with clear message when nil secret' do
      access_key, secret_key = get_creds
      args = {:access_key => access_key, :secret_key => nil}
      expect { Main::configure_aws args }.to raise_error
    end

  end

  context 'with logging' do

    after(:all) do
      File.delete LOG_FILE_NAME if File.exists? LOG_FILE_NAME
    end

    it 'should configure logging' do
      Main::configure_logging :bucket_name => :bname
      log = Logging.logger[self]
      log.add_appenders 's3'
      log.add_appenders LOG_FILE_NAME
    end

  end

  context 'with a simiulation context' do
    it 'should load a simulation context'
    it 'should handle poorly formatted contexts'
    it 'should handle a non-existant context'
  end
end