#!/usr/bin/env ruby

require 'sinatra/base'
require 'resolv'
require 'socket'

class Server < Sinatra::Base

  def assemble_link_name remote_name, local_name
    
  end

  def check_context link_name

  end

	get '/' do
		request.env.map{ |e| puts e.to_s + "\n"}
		ip_addr = request.env['REMOTE_ADDR']
    hostname = Resolv.new.getname ip_addr
    my_hostname = Socket::gethostname
		return "success! You are #{hostname} and your address is #{ip_addr}.\n"
	end
end

Server::run!