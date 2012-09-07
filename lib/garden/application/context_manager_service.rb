require 'socket'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::ContextManagerService < TestInterface
  enable :inline_templates

  @@factory =nil

  def self::initialize params
    ctx = params[:ctx]
    set ctx if ctx != nil
    @@syslog = Domain::ComponentFactory::instance \
      .create_system_log self.to_s
  end

  def self::set_test_params params
    @@factory = params[:factory]
  end

  def self::create_factory
    @@factory || ComponentFactory.new(:bucket_name => 'test')
  end

  get '/status/:id' do
    id = params[:id]
    halt 404
  end

end