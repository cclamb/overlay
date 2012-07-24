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
    def find_artifact *args
      $is_searched_for = true
      @mode ? 'artifact returned' : []
    end
    def find_artifacts *args
      $is_searched_for = true
      @mode ? 'artifact returned' : []
    end
  end

  class TestRouter
    @mode = false
    def find? mode
      @mode = mode
    end
    def find_artifact *args
      $is_searched_for = true
      @mode ? 'artifact returned' : []
    end
    def find_artifacts
      $is_searched_for = true
      @mode ? 'artifact returned' : []
    end
  end

  class TestFactory
    def create_node
      TestNode.new
    end
    def create_router
      TestRouter.new
    end
  end
end