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

  def artifact subject, device, key
    results = @dispatcher.dispatch_artifact subject, device, key
    @parent_dispatcher.dispatch_artifact subject, device, key if results.empty? && @parent_dispatcher != nil
  end 

  def artifacts subject, device
    results = @dispatcher.dispatch_artifacts subject, device
    @parent_dispatcher.dispatch_artifacts subject, device if results.empty? && @parent_dispatcher != nil
  end

end