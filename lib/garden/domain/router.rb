class Garden::Domain::Router

  def initialize args
    cnt = args.keys.count do |x| \
      x == :umm \
      || x == :dispatcher \
      || x == :rectifier \
    end
    raise 'must include a umm, rectifier, and dispacher' unless cnt == 3
    @repository = args[:repository]
    @context_factory = args[:context_factory]
    @umm = args[:umm]
    @dispatcher = args[:dispatcher]
    @rectifier = args[:rectifier]
  end

  def artifact subject, device, key

  end 

  def artifacts subject, device
    @dispatcher.dispatch_artifacts subject, device
  end

end