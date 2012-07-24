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
    results = @@node.find_artifact id
    handle_results results
  end

  get '/artifacts' do
    results = @@node.find_artifacts
    handle_results results
  end

  def handle_results results
    if results == nil || results.empty?
      halt 404
    else
      return results
    end
  end

end