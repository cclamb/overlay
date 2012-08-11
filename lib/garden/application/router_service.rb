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

  get '/artifact/*' do
    args = contextify params[:splat][0]
    results = @@router.find_artifact args[:username], args[:device], args[:id]
    handle_results results
  end

  get '/artifacts/*' do
    args = contextify params[:splat][0]
    results = @@router.find_artifacts args[:username], args[:device]
    handle_results results + args.to_s
  end

  def contextify str
    arr = str.split '/'
    h = {:username => arr[0], :device => arr[1]}
    h[:id] = arr[2] if arr.size > 2
    return h
  end

  def handle_results results
    if results == nil || results.empty?
      halt 404
    else
      return results
    end
  end

end