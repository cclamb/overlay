#--
# Copyright (c) 2012 Christopher C. Lamb
#
# SBIR DATA RIGHTS
# Contract No. FA8750-11-C-0195
# Contractor: AHS Engineering Services (under subcontract to Modus Operandi, Inc.)
# Address: 5909 Canyon Creek Drive NE, Albuquerque, NM 87111
# Expiration Date: 05/03/2018
# 
# The Government’s rights to use, modify, reproduce, release, perform, display, 
# or disclose technical data or computer software marked with this legend are 
# restricted during the period shown as provided in paragraph (b) (4) 
# of the Rights in Noncommercial Technical Data and Computer Software-Small 
# Business Innovative Research (SBIR) Program clause contained in the above 
# identified contract. No restrictions apply after the expiration date shown 
# above. Any reproduction of technical data, computer software, or portions 
# thereof marked with this legend must also reproduce the markings.
#++
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

    it 'should support posted alterations' do
      post "/status/#{edge_to_query}", :value => {:sensitivity => :unclassified}
      last_response.should be_ok
      get "/status/#{edge_to_query}"
      last_response.should be_ok
      last_response.body.should eq "{\"edge\":\"198.101.205.155_ec2-67-202-45-247.compute-1.amazonaws.com\",\"status\":{\"sensitivity\":\"unclassified\",\"category\":[\"magenta\"]}}"
    end

    it 'should support posted arrays' do
      post "/status/#{edge_to_query}", :value => {:category => [:large_pants]}
      last_response.should be_ok
      get "/status/#{edge_to_query}"
      last_response.should be_ok
      last_response.body.should eq "{\"edge\":\"198.101.205.155_ec2-67-202-45-247.compute-1.amazonaws.com\",\"status\":{\"sensitivity\":\"top_secret\",\"category\":[\"large_pants\"]}}"
    end

    it 'should return everything' do
      get "/status/all"
      last_response.should be_ok
      puts last_response.body
    end

  end

end