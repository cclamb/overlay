require 'rspec'
require 'rack/test'

require_relative '../../../lib/garden/application'
require_relative 'test'

include Garden

describe Application::PeerNodeService do
  include Rack::Test::Methods
  include Test

  def app
    Application::PeerNodeService::set_test_params \
      :factory => Test::TestFactory.new
    Application::PeerNodeService.new
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
      Test::TestFactory.find? false
      get_404 '/artifact/i-dont-exist'
      $is_searched_for.should eq true
    end
  end

end