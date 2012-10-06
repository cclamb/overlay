require 'rspec'
require 'rack/test'

require_relative '../../../lib/garden/application'
require_relative 'test'

include Garden

describe Application::ContextManagerService do
  include Rack::Test::Methods
  include Test

  def app
    Application::ContextManagerService::initialize
    Application::ContextManagerService.new
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

  context 'with the context interface' do

    it 'should return 404 if no content' do
      get_404 '/status/3to4'
    end

    it 'should return a record if content exists' do
      post '/status/1to2', :level => 'secret'
      get '/status/1to2'
      last_response.should be_ok
      last_response.body.should eq "{\"edge\":\"1to2\",\"status\":\"secret\"}"
    end

  end

end