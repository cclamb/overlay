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

	class TestFoundNode
	  def find_artifact *args
	    $is_searched_for = true
	    'this is a false artifact'
	  end
	end

	class TestNotFoundNode
	  def find_artifact *args
	    $is_searched_for = true
	    []
	  end
	end

	class TestFactory
	  def self::find? mode
	    @@mode = mode
	  end
	  def create_node args
	    if @@mode
	      TestFoundNode.new
	    else
	      TestNotFoundNode.new
	    end
	  end
	end
end