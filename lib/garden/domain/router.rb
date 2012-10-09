class Garden::Domain::Router

  def initialize args
    cnt = args.keys.count do |x| \
      x == :umm \
      || x == :dispatcher \
      || x == :rectifier 
    end
    raise 'must include a umm, rectifier, and dispacher' unless cnt == 3
    @repository = args[:repository]
    @context_factory = args[:context_factory]
    @umm = args[:umm]
    @dispatcher = args[:dispatcher]
    @rectifier = args[:rectifier]
    @parent_dispatcher = args[:parent_dispatcher]
  end

  def artifact subject, device, key, args = {}, is_standalone = nil
    results = @dispatcher.dispatch_artifact subject, device, key, args
    if results.empty? && @parent_dispatcher != nil && is_standalone == nil
      @parent_dispatcher.dispatch_artifact subject, device, key, args
    else
      results
    end
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