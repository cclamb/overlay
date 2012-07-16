require 'rspec'
require 'rack/test'

require_relative '../../../lib/application/peer_node_server'

def get_404 path
  get path
  last_response.status.should eq 404
end

def get_500 path
  get path
  last_response.status.should eq 500
end

$is_searched_for = false

class TestFoundNode
  def find_artifact *args
    $is_searched_for = true
    'this is a false artifact'
  end
end

class TestNotFoundNode
  def find_artifact *args
    $is_searched_for = true
    []
  end
end

class TestFactory
  def self::find? mode
    @@mode = mode
  end
  def create_node args
    if @@mode
      TestFoundNode.new
    else
      TestNotFoundNode.new
    end
  end
end

describe PeerNodeServer do
  include Rack::Test::Methods

  def app
    PeerNodeServer::set_test_params \
      :factory => TestFactory.new
    PeerNodeServer.new
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
      TestFactory.find? false
      get_404 '/artifact/i-dont-exist'
      $is_searched_for.should eq true
    end
  end

end