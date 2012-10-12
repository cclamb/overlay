class Garden::Domain::Router

  def initialize args
    @repository = args[:repository]
    @context_manager = args[:context_manager]
    @dispatcher = args[:dispatcher]
    @rectifier = args[:rectifier]
    @parent_dispatcher = args[:parent_dispatcher]
  end

  def artifact subject, device, key, args = {}, is_standalone = nil
    results = @dispatcher.dispatch_artifact subject, device, key, args
    if results.empty? && @parent_dispatcher != nil && is_standalone == nil
      results = @parent_dispatcher.dispatch_artifact subject, device, key, args
    end
    processed_results = []
    results.each { |object| processed_results.push(@rectifier.process :artifact => object, :context => @context_manager.context) }
    return processed_results
  end 

  def artifacts subject, device, args = {}, is_standalone = nil
    results = @dispatcher.dispatch_artifacts subject, device, args
    if @parent_dispatcher != nil && is_standalone == nil
      results | @parent_dispatcher.dispatch_artifacts(subject, device, args)
    else
      results
    end
  end

end