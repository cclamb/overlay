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
require 'sinatra/base'
require 'json'

require_relative '../../../lib/garden/domain'
require_relative '../../../etc/settings'

include Garden::Domain

class TestContextService < Sinatra::Base

  get '/status/:edge' do
    JSON::generate \
      :edge   => params[:edge],
      :status => {
        :sensitivity          => :secret,
        :category             => [:magenta],
        :mission_affiliation  => :flying_shrub,
        :organization         => :eurasia
      } 
  end

end

describe ContextManager do

  pid = nil

	before :all do
    pid = fork do
      $stdout = StringIO.new
      $stderr = StringIO.new
      TestContextService::set :port => Settings::CONTEXT_PORT_NUMBER
      TestContextService::run!
    end
	end

  it 'should return a context when requested' do
  	ContextManager.new('http://url.com').context('foo')[:link].should_not eq nil
  end

  it 'should return nil if link name is nil' do
  	ContextManager.new('http://url.com').context(nil).should eq nil
  end

  after(:all) do
    Process::kill :INT, pid
  end
  
end