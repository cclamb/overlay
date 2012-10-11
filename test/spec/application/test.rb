require 'rack/test'

module Test
  def get_404 path
    get path
    last_response.status.should eq 404
  end

  def get_500 path
    get path
    last_response.status.should eq 500
  end

  $is_searched_for = false

  class TestNode
    @mode = false
    def find? mode
      @mode = mode
    end
    def artifact *args
      $is_searched_for = true
      @mode ? 'artifact returned' : nil
    end
    def artifacts *args
      $is_searched_for = true
      @mode ? ['artifact returned'] : []
    end
  end

  class TestRouter
    @mode = false
    def find? mode
      @mode = mode
    end
    def artifact *args
      $is_searched_for = true
      @mode ? ['artifact returned'] : []
    end
    def artifacts *args
      $is_searched_for = true
      @mode ? ['artifact returned'] : []
    end
  end

  class TestContextManager
    @status = {}
    def set_edge_status e, s
      @status[k] = v
    end
    def remove_edge_status k
      @status[k] = nil
    end
  end

  class TestFactory
    def create_node
      TestNode.new
    end
    def create_router
      TestRouter.new
    end
    def create_context_manager
      TestContextManager.new
    end
  end

end