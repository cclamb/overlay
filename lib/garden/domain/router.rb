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
    responses = @dispatcher.dispatch_artifact subject, device, key
    bodies = []
    responses.each { |r| bodies.push r.body }
    bodies
  end 

  def artifacts subject, device
    responses = @dispatcher.dispatch_artifacts subject, device
    bodies = []
    responses.each { |r| bodies.push r.body }
    bodies
  end

end