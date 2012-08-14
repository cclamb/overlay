require 'rspec'

require_relative '../../../lib/garden/domain'

log_file_name = 'system.log'

include Garden::Domain

describe ComponentFactory do

  after(:all) do
    File.delete log_file_name if File.exists? log_file_name
  end

  it 'should be creatable' do
    factory = ComponentFactory::instance :bucket_name => 'test'
    factory.should_not eq nil
    factory = ComponentFactory::instance.should_not eq nil
  end

  it 'should create a usage manager' do
    ComponentFactory::instance(:bucket_name => 'foo').create_usage_manager.should_not eq nil
  end

  context 'with a LogFactory' do

    it 'should create a system log' do
      factory = ComponentFactory::instance :bucket_name => 'test'
      factory.create_system_log(self).should_not eq nil
    end

    it 'should create an overlay log' do
      factory = ComponentFactory::instance :bucket_name => 'test'
      factory.create_overlay_log(self).should_not eq nil
    end

  end

  context 'with a node factory' do

    it 'should create a node' do
      f = ComponentFactory::instance :bucket_name => 'test'
      yaml_values = { 'hostname' => 1, \
        'test_0' => 0, \
        'test_1' => 1, \
        'test_2' => 2 }
      node = f.create_node_record yaml_values
      node[:id].should eq 1
      node[:test_0].should eq 0
      node[:test_1].should eq 1
      node[:test_2].should eq 2
    end

  end

  context 'with an artifact repository' do

    creds_file_name = 'etc/creds.yaml'

    creds = YAML::load File::open(creds_file_name)

    access_key = creds['amazon']['access_key']
    secret_key = creds['amazon']['secret_key']

    AWS.config \
      :access_key_id => access_key, \
      :secret_access_key => secret_key

    it 'should create a respository with a valid URL to an S3 repo' do
      s3 = AWS::S3.new
      url = s3.buckets[:chrislambistan_repos] \
        .objects['repo_1.dat'] \
        .url_for :read
      uri = URI::parse url.to_s
      repo = ComponentFactory::instance.create_artifact_repo uri
      repo.should_not eq nil
      artifacts = repo.artifacts
      artifacts.should_not eq nil
      artifacts.size.should > 0
      artifact = repo.artifact :key_1
      artifact.should eq 'this is data from the repo'
    end

  end

end