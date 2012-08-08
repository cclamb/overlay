class Garden::Domain::Router

  def initialize args
    cnt = args.keys.count { |x| x == :repository || x == :umm || x == :dispatcher }
    raise 'must include a :repository, :umm, and :dispacher' unless cnt == 3
    @repository = args[:repository]
    @context_factory = args[:context_factory]
    @umm = args[:umm]
    @dispatcher = args[:dispatcher]
  end

  def artifact subject, device, key

  end

  def artifacts subject, device

  end

end