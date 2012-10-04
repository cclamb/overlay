require 'socket'
require 'net/http'
require 'uri'
require 'json'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::ContextManagerService < TestInterface
  enable :inline_templates

  @@ERROR_MESSAGE = {:error => 'unknown edge'}

  def self::initialize params
    #@@mgr = params[:mgr]
    @@repo = {}
    ctx = params[:ctx]
    set ctx if ctx != nil
    @@syslog = Domain::ComponentFactory::instance \
      .create_system_log self.to_s
    #@@status = { :level => :secret }
  end

  # get '/status/:id' do
  #   id = params[:id]
  #   halt 404
  # end

  def validate_level level
    level != nil \
      && ( level == :secret \
        || level == :top_secret \
        || level == :unclassified )
  end

  get '/status/:id' do
    id = params[:id]
    puts id
    puts @@repo
    content_type 'application/json', :charset => 'utf-8'
    JSON.generate @@repo[id] || @@ERROR_MESSAGE
  end

  post '/status/:id' do
    new_level = params[:level]
    id = params[:id]
    return if new_level == nil
    new_level = new_level.to_sym
    return unless validate_level new_level
    #@@status[:level] = new_level.to_sym
    @@repo[id] = new_level.to_sym
  end

end