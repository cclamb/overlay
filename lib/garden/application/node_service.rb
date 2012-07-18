require 'socket'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::NodeService < TestInterface
  enable :inline_templates

  @@factory =nil

  def self::set_test_params params
    @@factory = params[:factory]
  end

  def self::create_factory
    @@factory || ComponentFactory.new(:bucket_name => 'test')
  end

  get '/artifact/:id' do
    id = params[:id]
    factory = Garden::Application::NodeService::create_factory
    node = factory.create_node :hostname => Socket.gethostname
    response = node.find_artifact id
    halt 404
  end

end