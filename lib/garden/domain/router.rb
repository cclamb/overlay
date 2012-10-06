class Garden::Domain::Router

  def initialize args
    cnt = args.keys.count do |x| \
      x == :umm \
      || x == :dispatcher \
      || x == :rectifier \
      || x == :parent_dispatcher
    end
    raise 'must include a umm, rectifier, parent_dispatcher, and dispacher' unless cnt == 4
    @repository = args[:repository]
    @context_factory = args[:context_factory]
    @umm = args[:umm]
    @dispatcher = args[:dispatcher]
    @rectifier = args[:rectifier]
    @parent_dispatcher = args[:parent_dispatcher]
  end

  def artifact subject, device, key
    results = @dispatcher.dispatch_artifact subject, device, key
    @parent_dispatcher.dispatch_artifact subject, device, key if results.is_empty?
  end 

  def artifacts subject, device
    @dispatcher.dispatch_artifacts subject, device
    @parent_dispatcher.dispatch_artifacts subject, device if results.is_empty?
  end

end