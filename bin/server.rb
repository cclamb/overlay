#!/usr/bin/env ruby

require 'sinatra/base'

class Server < Sinatra::Base
	get '/' do
		request.env.map{ |e| puts e.to_s + "\n"}
		ip_addr = request.env.map['REMOTE_ADDR']
    hostname = Resolv.new.getname ip_addr
		return "success! You are #{hostname} and your address is #{ip_addr}.\n"
	end
end

Server::run!