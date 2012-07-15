require 'rspec'
require 'logging'
require 'socket'

require_relative '../../lib/domain/util'
require_relative '../../lib/domain/s_3'

CREDS_FILE_NAME = 'etc/creds.yaml'

def get_creds
  creds = YAML::load File::open(CREDS_FILE_NAME)
  return creds['amazon']['access_key'], creds['amazon']['secret_key']
end

describe Util do

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

end