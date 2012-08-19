class ArtifactRepository

  def initialize store = nil
    @store = store || {}
  end

  def artifact key
    @store[key]
  end

  def artifacts
    @store.keys
  end

end