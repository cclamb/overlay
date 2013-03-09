#!/usr/bin/env ruby

require 'sinatra/base'
require 'resolv'
require 'socket'
require 'net/http'

class Server < Sinatra::Base

  def my_first_private_ipv4
    Socket::ip_address_list.detect{|intf| intf.ipv4_private?}
  end

  def my_first_public_ipv4
    Socket::ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}
  end

  def build_name
    pub_addr  = my_first_public_ipv4
    if pub_addr == nil
      az_public_ip = Net::HTTP.get_response(URI::parse('http://instance-data.ec2.internal/latest/meta-data/public-ipv4')).body
      Resolv.new.getname az_public_ip
    else
      pub_addr.ip_address
    end
  end

  def build_remote_hostname ip_addr
    name = Resolv.new.getname ip_addr
    name =~ /amazon/ ? name : ip_addr
  end

  def build_link_name lhs, rhs
    "#{lhs}_#{rhs}"
  end

	get '/' do
		request.env.map{ |e| puts e.to_s + "\n"}
		ip_addr = request.env['REMOTE_ADDR']
    remote_hostname = build_remote_hostname ip_addr
    local_hostname = build_name
    link_name = build_link_name remote_hostname, local_hostname

msg=<<EOF
success! You are #{local_hostname} and your address is #{ip_addr}.
Also, the link name looks something like: #{link_name}\n
EOF

		return msg
	end
end

Server::run!