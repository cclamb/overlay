require 'socket'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class ContextManagerService < TestInterface
  enable :inline_templates

  @@factory =nil

  def self::set_test_params params
    @@factory = params[:factory]
  end

  def self::create_factory
    @@factory || ComponentFactory.new(:bucket_name => 'test')
  end

  get '/status/:id' do
    id = params[:id]
    factory = ContextManagerService::create_factory
    node = factory.create_node :hostname => Socket.gethostname
    response = node.find_artifact id
    halt 404
  end

end