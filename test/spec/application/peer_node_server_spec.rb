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

describe PeerNodeServer do
  include Rack::Test::Methods

  def app
    PeerNodeServer
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

end