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
    artifact_description = repository.artifact k
    return nil if ad == nil
    ctx = @context_factory.assemble_context subject, artifact_description, device
    bundles = @rectifier.partition ad
    bundles_to_return = []
    bundles.each do |bundle|
      bundles_to_return.push bundle if umm.execute? bundle.policy, ctx, :read
    end
    @rectifier.assemble bundles_to_return
  end

# ad = r.get_artifact(k)
# return nil if ad == nil
# ctx = cf.assemble_context(s, r, d)
# cbl = ar.partition(ad)
# for_each cb in cbl :
#   push(cbr, cb) if umm.can_execute(cb.policy, ctx, activity.read)
# adr = ar.assemble(ctr)
# return adr    

  def artifacts subject, device

  end

end