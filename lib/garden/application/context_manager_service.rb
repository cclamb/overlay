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
require 'socket'
require 'net/http'
require 'uri'
require 'json'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::ContextManagerService < TestInterface
  enable :inline_templates

  def self::load_initial_context filename
    instance_eval File.read(filename) || {}
  end

  def self::initialize params = {}
    @@repo = load_initial_context params[:initial_context_file]
    ctx = params[:ctx]
    set ctx if ctx != nil
    @@syslog = Domain::ComponentFactory::instance \
      .create_system_log self.to_s
  end

  def generate_return id
    status = @@repo[id] || halt(404)
    { :edge => id, :status => status }
  end

  get '/status/all' do
    @@repo
  end

  get '/status/:id' do
    id = params[:id]
    content_type 'application/json', :charset => 'utf-8'
    JSON.generate generate_return(id)
  end

  post '/status/:id' do
    new_level = params[:value]
    id = params[:id]
# params.each { |k,v| puts "#{k} : #{v}"}
# puts "#{id} : #{params[:value]}"
    return if new_level == nil

    new_level = new_level.kind_of?(String) ? instance_eval(new_level) : new_level

    new_level.each do |k,v|
      bag = @@repo[id] || {}

      if v.kind_of? Array
        new_v = []
        v.each { |v| new_v.push v.to_sym }
        bag[k.to_sym] = new_v
      else
        bag[k.to_sym] = v.to_sym
      end
      @@repo[id] = bag
    end

    @@repo[id]
  end

end