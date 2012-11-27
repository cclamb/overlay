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
require 'net/http'
require 'uri'

require_relative '../../../etc/settings'

class Garden::Domain::ContextManager

  def initialize server_url
    base_url = "#{server_url}:#{Settings::CONTEXT_PORT_NUMBER}"
    @status_api = {
      :status => ->(id){
        uri = URI::parse "#{base_url}/status/#{id}"
        response = Net::HTTP.get_response uri
        response.code == '200' ? JSON::load(response.body) : nil
      },
      :all    => ->(){
        uri = URI::parse "#{base_url}/all"
        response = Net::HTTP.get_response uri
        response.code == '200' ? JSON::load(response.body) : nil
      }
    }
  end

	def context link_name
    return nil if link_name == nil
    @status_api[:status].call link_name
    { 
      :link => {
        :sensitivity => :secret,
        :category => :magenta,
        :organization => :eurasia,
        :mission_affiliation => :flying_shrub
      },
      :user => {
        :clearance => :top_secret,
        :category => :magenta,
        :organziation => :oceania,
        :mission_affiliation => :parched_iguana,
        :device => :tablet
      }
    }
	end

end