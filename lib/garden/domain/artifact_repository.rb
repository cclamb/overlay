class ArtifactRepository

  def initialize store
    @store = store
  end

  def artifact key
    @store[key]
  end

  def artifacts
    @store.keys
  end

end