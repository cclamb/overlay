#!/usr/bin/env ruby

require 'socket'
require 'resolv'
require 'net/http'

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

priv = my_first_private_ipv4
private_addr = priv ? priv.ip_address : 'none'
pub  = my_first_public_ipv4
public_addr = pub ? pub.ip_address : 'none'

puts "Private: #{private_addr}\n"
puts "Public: #{public_addr}\n"

puts "Built name: #{build_name}"



#require 'resolv'
# ip_addr = '198.101.205.153'
# resolver = Resolv.new
# hostname = resolver.getname ip_addr
# puts "System name: #{hostname}\n"


