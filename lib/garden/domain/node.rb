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
class Garden::Domain::Node

  def initialize args
    @repository = args[:repository]
    @rectifier = args[:rectifier]
    @dispatcher = args[:dispatcher]
    @context_manager = args[:context_manager]
    @syslog = Domain::ComponentFactory::instance \
      .create_system_log self.to_s
  end

  def artifact subject, device, key, is_standalone = nil
    # @syslog.info "processing artifact request: #{subject} #{device} #{key} : #{@repository.inspect}"
    return nil if key == nil || @repository == nil
    artifact = @repository.artifact(key.to_sym) || @repository.artifact(key)
    #@syslog.info "artifact : #{artifact.inspect}"
    if artifact == nil && is_standalone == nil
      artifacts = @dispatcher.dispatch_artifact subject, device, key
      artifact = artifacts.pop
    end
    #@syslog.info "artifact: #{artifact}"
    link_name = begin
        Util::assemble_link_name remote_ip_addr
      rescue Exception => e
        nil
      end

    global_ctx = @context_manager.context(link_name)
    link_ctx = global_ctx ? global_ctx[:link] : nil
    @rectifier.process :artifact => artifact, :context => link_ctx
  end

  def artifacts subject, device, is_standalone = nil
    keys = @repository.artifacts
    keys = keys | @dispatcher.dispatch_artifacts(subject, device) if is_standalone == nil
    keys.to_s
  end

end