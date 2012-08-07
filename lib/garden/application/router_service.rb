require 'socket'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::RouterService < TestInterface
  enable :inline_templates

  def self::initialize params
    @@router = params[:router]
    ctx = params[:ctx]
    set ctx if ctx != nil
  end

  get '/artifact/:id' do
    id = params[:id]
    results = @@router.find_artifact id
    handle_results results
  end

  get '/artifacts' do
    results = @@router.find_artifacts
    handle_results results
  end

  def handle_results results
    if results == nil || results.empty?
      halt 404
    else
      return results
    end
  end

  # def self.start params
  #   ctx = params[:ctx]
  #   set ctx if ctx != nil
  #   @@context = params[:ctx_mgr]
  #   @@nodes = params[:nodes]
  #   @@routers = params[:routers]

  #   puts "************************************\n"
  #   puts "Router running on port #{ctx[:port]}\n"
  #   puts "\tchildren: #{@@nodes}\n"
  #   puts "\trouters: #{@@routers}\n"
  #   puts "************************************\n"

  #   run!
  # end

end