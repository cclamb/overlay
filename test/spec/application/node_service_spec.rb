require 'rspec'
require 'rack/test'

require_relative '../../../lib/garden/application'
require_relative 'test'

include Garden

describe Application::NodeService do
  include Rack::Test::Methods
  include Test

  def initialize
    factory = Test::TestFactory.new
    @node = factory.create_node
  end

  def app
    # Application::NodeService::set_test_params \
    #   :factory => Test::TestFactory.new
    # Application::NodeService.new
    Application::NodeService::initialize :node => @node
    Application::NodeService.new
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
      $is_searched_for = false
      @node.find? false
      get_404 '/artifact/i-dont-exist'
      $is_searched_for.should eq true
    end

    it 'should return content that does exist' do
      $is_searched_for = false
      @node.find? true
      get '/artifact/something'
      last_response.should be_ok
      $is_searched_for.should eq true
    end

    it 'should return 404 when not content is found on node matching query params' do
      $is_searched_for = false
      @node.find? false
      get_404 '/artifacts/'
      $is_searched_for.should eq true
    end

    it 'should return keys to all content that matches query params' do
      $is_searched_for = false
      @node.find? true
      get '/artifacts/'
      last_response.should be_ok
      $is_searched_for.should eq true
    end

  end

end