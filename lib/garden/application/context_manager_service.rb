require 'socket'
require 'net/http'
require 'uri'
require 'json'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::ContextManagerService < TestInterface
  enable :inline_templates

  def self::initialize params = {}
    @@repo = {}
    ctx = params[:ctx]
    set ctx if ctx != nil
    @@syslog = Domain::ComponentFactory::instance \
      .create_system_log self.to_s
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

  def generate_return id
    status = @@repo[id] || halt(404)
    { :edge => id, :status => status }
  end

  get '/status/:id' do
    id = params[:id]
    content_type 'application/json', :charset => 'utf-8'
    JSON.generate generate_return(id)
  end

  post '/status/all' do
    params.each { |k,v| puts "(#{k})-->:\n #{v}\n\n" }
    #puts "-->: \n #{params[:sensitivity]}"
    #x = eval params
    #puts "-->: \n #{x[:sensitivity]}"
    'recieved'
  end

  post '/status/:id' do
    new_level = params[:level]
    id = params[:id]
    return if new_level == nil
    new_level = new_level.to_sym
    return unless validate_level new_level
    @@repo[id] = new_level.to_sym
  end

end