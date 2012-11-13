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
require 'base64'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::RouterService < TestInterface
  enable :inline_templates

  def self::initialize params
    @@syslog = Domain::ComponentFactory::instance.create_system_log self
    @@router = params[:router]
    ctx = params[:ctx]
    set ctx if ctx != nil
  end

  get '/artifact/*' do
    begin
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 3
      results = @@router.artifact args[:username], args[:device], args[:id]
      handle_result results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  get '/artifacts/*' do
    begin
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 2
      results = @@router.artifacts args[:username], args[:device]
      handle_results results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  get '/search/artifact/*' do
    begin
      visited_nodes_m_enc = request.env['HTTP_X_OVERLAY_VISITED_NODES']
      visited_nodes = Marshal.load(Base64.decode64 visited_nodes_m_enc)
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 3
      results = @@router.artifact \
        args[:username], \
        args[:device], \
        args[:id], \
        { :visited_nodes => visited_nodes }
      handle_result results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  get '/search/artifacts/*' do
    begin
      visited_nodes_m_enc = request.env['HTTP_X_OVERLAY_VISITED_NODES']
      visited_nodes = Marshal.load(Base64.decode64 visited_nodes_m_enc)
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 2
      results = @@router.artifacts \
        args[:username], \
        args[:device], \
        { :visited_nodes => visited_nodes }
      handle_results results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  def contextify str
    arr = str.split '/'
    h = {:username => arr[0], :device => arr[1]}
    h[:id] = arr[2] if arr.size > 2
    return h
  end

  def handle_result results
    if results == nil || results.empty? == true
      halt 404
    else
      @@syslog.info "(router) returning artifact."
      return results.shift
    end
  end

  def handle_results results
    if results == nil || results.empty?
      halt 404
    else
      return results.to_s.gsub!(/(\[|\"|,)/, '').gsub!(/(\]|\s+)/, ' ')
    end
  end

end