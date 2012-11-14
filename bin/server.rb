#!/usr/bin/env ruby

require 'sinatra/base'

class Server < Sinatra::Base
	get '/' do
		request.env.map{ |e| puts e.to_s + "\n"}
		return "success!\n"
	end
end

Server::run!