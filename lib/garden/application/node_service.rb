require 'socket'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::NodeService < TestInterface
  enable :inline_templates

  def self::initialize params
    @@node = params[:node]
    ctx = params[:ctx]
    set ctx if ctx != nil
    @@syslog = Domain::ComponentFactory::instance \
      .create_system_log self.to_s
  end

  get '/artifact/*' do
    begin
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 3
      results = @@node.artifact args[:username], args[:device], args[:id]
      handle_result results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  get '/artifacts/*' do
    begin
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 2
      results = @@node.artifacts args[:username], args[:device]
      handle_results results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  get '/search/artifact/*' do
    begin
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 3
      results = @@node.artifact args[:username], args[:device], args[:id], :standalone
      # @@syslog.info results.inspect
      handle_result results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  get '/search/artifacts/*' do
    begin
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 2
      results = @@node.artifacts args[:username], args[:device], :standalone
      handle_results results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  def contextify str
    arr = str.split '/'
    h = {:username => arr[0], :device => arr[1]}
    h[:id] = arr[2] if arr.size > 2
    return h
  end

  def handle_result result
    if result == nil
      halt 404
    else
      return result
    end
  end

  def handle_results results
    if results == nil || results.empty?
      halt 404
    else
      return results.to_s.gsub!(/(\[|\"|,)/, '').gsub!(/(\]|\s)/, ' ')
    end
  end

end