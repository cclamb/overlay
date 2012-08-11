class Garden::Domain::Node

  def initialize args
    cnt = args.keys.count { |x| x == :repository || x == :umm }
    raise 'must include a :repository and a :umm' unless cnt == 2
    @repository = args[:repository]
    @context_factory = args[:context_factory]
    @umm = args[:umm]
  end

  def artifact subject, device, key
    artifact_description = repository.artifact k
    return nil if artifact_description == nil
    ctx = @context_factory.assemble_context subject, artifact_description, device
    bundles = @rectifier.partition artifact_description
    bundles_to_return = []
    bundles.each do |bundle|
      bundles_to_return.push bundle if umm.execute? bundle.policy, ctx, :read
    end
    @rectifier.assemble bundles_to_return
  end

  def artifacts subject, device
    respository.artifacts
  end

end