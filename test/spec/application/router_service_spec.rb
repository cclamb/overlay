require 'rspec'
require 'rack/test'

require_relative '../../../lib/garden/application'
require_relative 'test'

include Garden

describe Application::RouterService do
  include Rack::Test::Methods
  include Test

  def initialize
    factory = Test::TestFactory.new
    @router = factory.create_router
  end

  def app
    Application::RouterService::initialize :router => @router
    Application::RouterService.new
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
      @router.find? false
      get_404 '/artifact/i-dont-exist'
      $is_searched_for.should eq true
    end

    it 'should return all located content'
    it 'should query for conent based on submitted params'
  end

end