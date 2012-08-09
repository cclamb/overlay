class Garden::Domain::Node

  def initialize args
    cnt = args.keys.count { |x| x == :repository || x == :umm }
    raise 'must include a :repository, :umm, and :dispacher' unless cnt == 2
    @repository = args[:repository]
    @context_factory = args[:context_factory]
    @umm = args[:umm]
  end

  def artifact subject, device, key

  end

  def artifacts subject, device

  end

end