class Garden::Domain::Router

  def initialize args
    cnt = args.keys.count do |x| \
      x == :repository \
      || x == :umm \
      || x == :dispatcher \
      || x == :rectifier \
    end
    raise 'must include a :repository, :umm, rectifier, and :dispacher' unless cnt == 4
    @repository = args[:repository]
    @context_factory = args[:context_factory]
    @umm = args[:umm]
    @dispatcher = args[:dispatcher]
    @rectifier = args[:rectifier]
  end

  def artifact subject, device, key

  end 

  def artifacts subject, device
    @dispatcher.dispatch subject, device
  end

end