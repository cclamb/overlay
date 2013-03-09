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
require_relative '../util'

class Garden::Domain::Router

  def initialize args
    @repository = args[:repository]
    @context_manager = args[:context_manager]
    @dispatcher = args[:dispatcher]
    @rectifier = args[:rectifier]
    @parent_dispatcher = args[:parent_dispatcher]
  end

  def artifact subject, device, key, remote_ip_addr, args = {}, is_standalone = nil
    results = @dispatcher.dispatch_artifact subject, device, key, args
    if results.empty? && @parent_dispatcher != nil && is_standalone == nil
      results = @parent_dispatcher.dispatch_artifact subject, device, key, args
    end
    processed_results = []
    results.each do |object|
      link_name = begin
        Util::assemble_link_name remote_ip_addr
      rescue Exception => e
        nil
      end

      global_ctx = @context_manager.context(link_name)
      link_ctx = global_ctx ? global_ctx[:link] : nil
      rectified_object = @rectifier.process \
          :artifact => object, 
          :context => link_ctx
      processed_results.push rectified_object
    end
    return processed_results
  end 

  def artifacts subject, device, remote_ip_addr, args = {}, is_standalone = nil
    results = @dispatcher.dispatch_artifacts subject, device, args
    if @parent_dispatcher != nil && is_standalone == nil
      results | @parent_dispatcher.dispatch_artifacts(subject, device, args)
    else
      results
    end
  end

end