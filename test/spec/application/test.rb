#--
# Copyright (c) 2012 Christopher C. Lamb
#
# SBIR DATA RIGHTS
# Contract No. FA8750-11-C-0195
# Contractor: AHS Engineering Services (under subcontract to Modus Operandi, Inc.)
# Address: 5909 Canyon Creek Drive NE, Albuquerque, NM 87111
# Expiration Date: 05/03/2018
# 
# The Government’s rights to use, modify, reproduce, release, perform, display, 
# or disclose technical data or computer software marked with this legend are 
# restricted during the period shown as provided in paragraph (b) (4) 
# of the Rights in Noncommercial Technical Data and Computer Software-Small 
# Business Innovative Research (SBIR) Program clause contained in the above 
# identified contract. No restrictions apply after the expiration date shown 
# above. Any reproduction of technical data, computer software, or portions 
# thereof marked with this legend must also reproduce the markings.
#++
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