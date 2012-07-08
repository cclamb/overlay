require 'rspec'
require 'aws-sdk'

require_relative '../../lib/configuration_repository'

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
    it 'should grab an S3 item'
  end
end