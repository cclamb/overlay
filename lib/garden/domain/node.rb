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
    @rectifier.process :artifact => artifact, :context => @context_manager.context
  end

  def artifacts subject, device, is_standalone = nil
    keys = @repository.artifacts
    keys = keys | @dispatcher.dispatch_artifacts(subject, device) if is_standalone == nil
    keys.to_s
  end

end