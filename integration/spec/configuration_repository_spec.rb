require 'rspec'
require 'aws-sdk'

require_relative '../../lib/garden'

include Garden

module ConfigurationRepositoryIntegrationTest
  def ConfigurationRepositoryIntegrationTest::build_config_uri
    s3 = AWS::S3.new
    url = s3.buckets[:chrislambistan_configuration] \
      .objects['current'] \
      .url_for :read
    uri = URI::parse url.to_s
  end
end

describe ConfigurationRepository do

  before(:all) do
    creds_file_name = 'etc/creds.yaml'
    creds = YAML::load File::open(creds_file_name)
    AWS.config \
      :access_key_id => creds['amazon']['access_key'], \
      :secret_access_key => creds['amazon']['secret_key']
  end

  context 'with a nil URI' do
    it 'should throw an exception on creation' do
      expect { repo = ConfigurationRepository.new nil }.to raise_error
    end
  end
  context 'with a valid URI' do
    it 'should grab an S3 item' do
      repo = ConfigurationRepository.new ConfigurationRepositoryIntegrationTest::build_config_uri
      cfg = repo.get_configuration 'rs0'
      cfg.should_not eq nil
    end
  end
end