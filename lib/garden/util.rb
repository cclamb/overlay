
require 'logging'
require 'socket'
require 'uri'

# TODO: remove this temporary component factory
require_relative '../../test/spec/application/test'
require_relative 'domain/component_factory'

module Garden

  # The file in which to store the saved PID for process control.
  PID_FILE_NAME = '.overlay_pid'

  # Various utility methods used in the system.  This is
  # essentially a factor module for various components that
  # require similar configuration and are used globaly.
  module Util

    # Configuring the AWS-SDK with access and secret keys.
    def Util::configure_aws args
      raise 'secret key is nil' if args[:secret_key] == nil
      raise 'access key is nil' if args[:access_key] == nil
      AWS.config \
        :access_key_id => args[:access_key], \
        :secret_access_key => args[:secret_key]
    end

    # Process the arguments on the command line.  We expect the
    # order to be:
    # * The URL of the configuration document generated from S3
    # * The S3 access key
    # * The S3 secret key
    # * The S3 location to log overlay specific operational state
    def Util::process_args args
      {:context_url => args[0], \
        :access_key => args[1], \
        :secret_key => args[2], \
        :bucket_name => args[3] }
    end


    # Save a PID of the current process for process control if
    # needed.  If the PID file already exists, stop the previous
    # pid and clear the file.
    def Util::save_pid
      stop_running_process
      File::write PID_FILE_NAME, Process::pid
    end

    # If a PID file exists, read the PID, stop the running
    # process, then delete the PID file.
    def Util::stop_running_process
      return if !File::exists? PID_FILE_NAME
      pid = File.read(PID_FILE_NAME).to_i
      begin
        Process::kill :INT, pid
      rescue
      end
      File::delete PID_FILE_NAME
    end

    # Starting the node on the server by type.
    def Util::start cfg
      syslog = Domain::ComponentFactory::instance.create_system_log 'Util::start'
      if cfg.is_router?
        syslog.info 'starting router'
        Util::run_as_router cfg
      elsif cfg.is_node?
        syslog.info 'starting node'
        Util::run_as_node cfg
      elsif cfg.is_peer_node?
        syslog.info 'starting peer node'
        Util::run_as_peer_node
      elsif cfg.is_context_server?
        syslog.info 'starting context server'
        Util::run_as_context_server
      else
        syslog.info 'A run type was not submitted in the context; exiting.'
      end
    end

    # Starting a router.
    def Util::run_as_router cfg
      router = Domain::ComponentFactory::instance.create_router cfg.children
      Application::RouterService::initialize \
        :router => router, \
        :ctx => { :port => 6789 }

      Application::RouterService::run!
    end

    # Starting a node.
    def Util::run_as_node cfg
      node = Domain::ComponentFactory::instance.create_node Util::generate_repo_uri(cfg.repository_name)
      Application::NodeService::initialize \
        :node => node, \
        :ctx => { :port => 6789 }

      Application::NodeService::run!
    end

    # Starting a peer node.
    def Util::run_as_peer_node

    end

    # Starting a context server.
    def Util::run_as_context_server

    end

    def Util::read_object_from_s3 uri
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
    end

    def Util::generate_repo_uri repo_name
      return nil if repo_name == nil
      s3 = AWS::S3.new
      url = s3.buckets[:chrislambistan_repos] \
        .objects[repo_name] \
        .url_for :read
      url == nil ? url : URI::parse(url.to_s)
    end

    def Util::process_error reporter, msg, err
      syslog = Domain::ComponentFactory::instance.create_system_log reporter.to_s
      syslog.error 'Node has crashed!'
      syslog.error err.to_s
      err.backtrace.each do |s|
        syslog.error "\t#{s}"
      end
    end

  end

end