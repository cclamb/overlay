require 'socket'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::RouterService < TestInterface
  enable :inline_templates

  def self::initialize params
    @@router = params[:router]
  end

  get '/artifact/:id' do
    id = params[:id]
    results = @@router.find_artifact id
    handle_results results
  end

  get '/artifacts' do

  end

  def handle_results results
    if results == nil || results.empty?
      halt 404
    else
      return results
    end
  end

end