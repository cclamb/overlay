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
require 'base64'
require 'uri'
require 'net/http'

include Garden

class Garden::Domain::Dispatcher

  def initialize nodes, port, name
    @syslog = Domain::ComponentFactory::instance.create_system_log self
    @nodes = nodes
    @port = port
    @name = name
  end

  def dispatch_artifacts subject, device, args = {}
      responses = []
      visited_nodes = args[:visited_nodes] || []
      visited_nodes.push @name
      @nodes.each do |node|
        if visited_nodes.include? node
          @syslog.info "Skipping #{node}..."
          next
        end
        uri_string = "#{node}:#{@port}/search/artifacts/#{subject}/#{device}"
        # @syslog.info "submitting to node: #{uri_string}"
        uri = URI.parse uri_string
        response = send_request uri, visited_nodes
        responses.push response.body if response.code == '200'
        visited_nodes.push node
      end
      @syslog.info "responses are: #{responses}"
      return responses
  end

  def dispatch_artifact subject, device, id, args = {}
      responses = []
      visited_nodes = args[:visited_nodes] || []
      visited_nodes.push @name
      @nodes.each do |node|
        next if visited_nodes.include? node
        uri_string = "#{node}:#{@port}/search/artifact/#{subject}/#{device}/#{id}"
        #@syslog.info "submitting to node: #{uri_string}"
        uri = URI.parse uri_string
        response = send_request uri, visited_nodes
        #@syslog.info "Body is: #{response.body}" if response.code == '200'
        responses.push response.body if response.code == '200'
        visited_nodes.push node
      end
      #@syslog.info "Responses are: #{responses}"
      return responses   
  end

  private

  def send_request uri, visited_nodes
    response = nil
    visited_nodes = Base64.encode64(Marshal.dump visited_nodes)
    begin
      http = Net::HTTP.new uri.host, uri.port
      request = Net::HTTP::Get.new uri.request_uri, \
        'X-Overlay-Visited-Nodes' => visited_nodes
      response = http.request request
    rescue RuntimeError => err
      @syslog.error "error thrown in dispatcher: #{err}"
    end
  end

end