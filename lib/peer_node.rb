
class PeerNode

  def initialize artifact_repo = [], &search_adapter = nil
    @artifact_repo = artifact_repo
    @search_adapter = search_adapter
  end

  def find_artifact id, search_ctx = {}, remote_ctx = {}
    return [] if id == nil || search_ctx == nil || remote_ctx == nil
    hop_count = search_ctx[:hop_count]
    local_results = @artifact_repo.select { |record| record[:id] == id }
    remote_results = if search_remotely? hop_count
      @search_adapter.find_artifact id, search_context, remote_ctx
    end
  end

  def find_available_artifacts id, search_ctx, remote_ctx

  end

  private

  def search_remotely? hop_count
    hop_count != nil && hop_count > 0
  end
  
end