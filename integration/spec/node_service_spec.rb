require 'rspec'
require 'rack/test'

require_relative '../../lib/garden'
require_relative '../../test/spec/application/test'
require_relative '../../lib/garden/util/test_interface'

module NodeServiceIntegrationTest
  def NodeServiceIntegrationTest::build_raw_repo_uri
    s3 = AWS::S3.new
    url = s3.buckets[:chrislambistan_repos] \
      .objects['repo_1.dat'] \
      .url_for :read
    uri = URI::parse url.to_s
  end
end

include Garden

pid = nil

class ParentService < TestInterface
  get '/search/artifacts/*' do
    'retrieve search artifacts'
  end
  get '/search/artifact/*' do
    'retrieved a search artifact'
  end
  get '/artifacts/*' do
    'retrieved artifacts'
  end
  get '/artifact/*' do
    'retrieved an artifact'
  end
end

describe Application::NodeService do
  include Rack::Test::Methods
  include Test

  def app
    Application::NodeService::initialize :node => @node
    Application::NodeService.new
  end

  before(:all) do
    creds_file_name = 'etc/creds.yaml'

    creds = YAML::load File::open(creds_file_name)

    access_key = creds['amazon']['access_key']
    secret_key = creds['amazon']['secret_key']

    AWS.config \
      :access_key_id => access_key, \
      :secret_access_key => secret_key

    factory = Domain::ComponentFactory.new :bucket_name => 'foo'
    @node = factory.create_node 'http://localhost:6789', NodeServiceIntegrationTest::build_raw_repo_uri

    Domain::ComponentFactory::instance :bucket_name => 'foo'
    pid = fork do
      $stdout = StringIO.new
      $stderr = StringIO.new
      ParentService::run!
    end
    sleep 1
  end

  after(:all) do
    File.delete('system.log') if File.exists?('system.log')
    Process::kill :KILL, pid
  end

  context 'with the test interface' do

    it 'should integrate the test interface' do
      get '/test'
      last_response.should be_ok
      fail 'incorrect body' unless last_response.body =~ /Howdy/
    end

    it 'should return 404' do
      get_404 '/test/error/404'
    end

    it 'should return 500' do
      get_500 '/test/error/500'
    end

  end

  context 'with the content interface' do

    it 'should return 404 when content does not exist' do
      get_404 '/artifact/i-dont-exist'
      get_404 '/artifact/name/device'
      get_404 '/artifact/fooname/iphone/key'
    end

    it 'should return content that does exist' do
      get '/artifact/sam/workstation/key_1'
      last_response.should be_ok
    end

    it 'should return keys to all content that matches query params' do
      get '/artifacts/'
      last_response.should be_ok
    end

  end

  context 'with the search interface' do

    it 'should return 404 when content does not exist' do
      get_404 '/search/artifact/i-dont-exist'
      get_404 '/search/artifact/name/device'
      get_404 '/search/artifact/fooname/iphone/key'
    end

    it 'should return content that does exist' do
      get '/search/artifact/sam/workstation/key_1'
      last_response.should be_ok
    end

    it 'should return keys to all content that matches query params' do
      get '/search/artifacts/'
      last_response.should be_ok
    end

  end

end