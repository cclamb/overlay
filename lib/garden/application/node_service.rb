require 'socket'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::NodeService < TestInterface
  enable :inline_templates

  def self::initialize params
    @@node = params[:node]
  end

  get '/artifact/:id' do
    id = params[:id]
    response = @@node.find_artifact id
    halt 404
  end

end