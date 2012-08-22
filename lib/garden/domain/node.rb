class Garden::Domain::Node

  def initialize args
    cnt = args.keys.count { |x| x == :repository || x == :umm  || x == :dispatcher}
    raise 'must include a :repository, :dispatcher, and a :umm' unless cnt == 3
    @repository = args[:repository]
    @context_factory = args[:context_factory]
    @dispatcher = args[:dispatcher]
    @umm = args[:umm]
  end

  def artifact subject, device, key, is_standalone = nil
    return nil if key == nil || @repository == nil
    artifact = @repository.artifact(key.to_sym) || @repository.artifact(key)
    # if artifact == nil && is_standalone == nil
    #   artifacts = @dispatcher.dispatch_artifact subject, device, key
    #   artifact = artifacts.pop
    # end
    # artifact
    # TODO: Uncomment when integrating UMM
    #
    # ctx = @context_factory.assemble_context subject, artifact_description, device
    # bundles = @rectifier.partition artifact_description
    # bundles_to_return = []
    # bundles.each do |bundle|
    #   bundles_to_return.push bundle if umm.execute? bundle.policy, ctx, :read
    # end
    # @rectifier.assemble bundles_to_return
  end

  def artifacts subject, device, is_standalone = nil
    keys = @repository.artifacts
    keys =  @dispatcher.dispatch_artifacts(subject, device) if keys == nil && is_standalone == nil
    keys.to_s
  end

end