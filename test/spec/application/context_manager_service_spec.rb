require 'rspec'
require 'rack/test'
require 'base64'

require_relative '../../../lib/garden/application'
require_relative 'test'

include Garden

describe Application::ContextManagerService do
  include Rack::Test::Methods
  include Test

  def app
    filename = "#{File.dirname __FILE__}/../../../etc/1_2_2_initial_context.rb"
    Application::ContextManagerService::initialize :initial_context_file => filename
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

    edge_to_query = '198.101.205.155_ec2-67-202-45-247.compute-1.amazonaws.com'

    it 'should return 404 if no content' do
      get_404 '/status/3to4'
    end

    it 'should return correct content from the initial context loaded' do
      get "/status/#{edge_to_query}"
      last_response.should be_ok
      last_response.body.should eq "{\"edge\":\"198.101.205.155_ec2-67-202-45-247.compute-1.amazonaws.com\",\"status\":{\"sensitivity\":\"top_secret\",\"category\":[\"magenta\"]}}"
    end

    it 'should return a record if content exists' do
      status = {:sensitivity => :secret, :category => [:vermillion]}
      puts Base64::encode64 Marshal::dump(status)
      post "/status/#{edge_to_query}", :level => Base64::encode64(Marshal::dump status)
      # get "/status/#{edge_to_query}"
      # last_response.should be_ok
      # puts "LAST RESPONSE: #{last_response.body}"
      # last_response.body.should eq "{\"edge\":\"#{edge_to_query}\",\"status\":\"secret\"}"
    end

  end

end