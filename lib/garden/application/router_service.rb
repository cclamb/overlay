require 'socket'
require 'base64'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::RouterService < TestInterface
  enable :inline_templates

  def self::initialize params
    @@syslog = Domain::ComponentFactory::instance.create_system_log 'router_service'
    @@router = params[:router]
    ctx = params[:ctx]
    set ctx if ctx != nil
  end

  get '/artifact/*' do
    begin
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 3
      results = @@router.artifact args[:username], args[:device], args[:id]
      handle_results results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  get '/artifacts/*' do
    begin
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 2
      results = @@router.artifacts args[:username], args[:device]
      handle_results results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  get '/search/artifact/*' do
    begin
      visited_nodes_m_enc = request.env['HTTP_X_OVERLAY_VISITED_NODES']
      visited_nodes = Marshal.load(Base64.decode64 visited_nodes_m_enc)
      @@syslog.info "==> Nodes visited include #{visited_nodes}"
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 3
      results = @@router.artifact \
        args[:username], \
        args[:device], \
        args[:id], \
        { :visited_nodes => visited_nodes } #, \
        # :standalone
      handle_results results
    rescue Exception => err
      Util::process_error self.to_s,'error in artifact operation', err
      halt 500
    end
  end

  get '/search/artifacts/*' do
    begin
      visited_nodes_m_enc = request.env['HTTP_X_OVERLAY_VISITED_NODES']
      visited_nodes = Marshal.load(Base64.decode64 visited_nodes_m_enc)
      @@syslog.info "==> Nodes visited include #{visited_nodes}"
      args = contextify params[:splat][0]
      halt 404 if args == nil || args.size < 2
      results = @@router.artifacts \
        args[:username], \
        args[:device], \
        { :visited_nodes => visited_nodes } #, \
        # :standalone
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

  def handle_results results
    if results == nil || results.empty?
      halt 404
    else
      return results.to_s.gsub!(/(\[|\"|,)/, '').gsub!(/(\]|\w)/, ' ')
    end
  end

end