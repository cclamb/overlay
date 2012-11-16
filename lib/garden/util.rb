#--
# Copyright (c) 2012 Christopher C. Lamb
#
# SBIR DATA RIGHTS
# Contract No. FA8750-11-C-0195
# Contractor: AHS Engineering Services (under subcontract to Modus Operandi, Inc.)
# Address: 5909 Canyon Creek Drive NE, Albuquerque, NM 87111
# Expiration Date: 05/03/2018
# 
# The Government’s rights to use, modify, reproduce, release, perform, display, 
# or disclose technical data or computer software marked with this legend are 
# restricted during the period shown as provided in paragraph (b) (4) 
# of the Rights in Noncommercial Technical Data and Computer Software-Small 
# Business Innovative Research (SBIR) Program clause contained in the above 
# identified contract. No restrictions apply after the expiration date shown 
# above. Any reproduction of technical data, computer software, or portions 
# thereof marked with this legend must also reproduce the markings.
#++
# Utility functions and classes used in the system.  Many
# of the utility functions are maintained in a Garden::Util
# module.
require 'logging'
require 'socket'
require 'uri'

# TODO: remove this temporary component factory
require_relative '../../test/spec/application/test'
require_relative 'domain/component_factory'
require_relative '../../etc/settings'

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
      return unless File::exists? PID_FILE_NAME
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
        syslog.info "starting router"
        Util::run_as_router cfg
      elsif cfg.is_node?
        syslog.info "starting node"
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
      syslog = Domain::ComponentFactory::instance.create_system_log 'Util::start'
      router = Domain::ComponentFactory::instance.create_router \
        :children => cfg.children,
        :parent => cfg.parent,
        :name => cfg.name,
        :managed => cfg.managed?,
        :confidentiality_strategy => cfg.confidentiality_strategy
      Application::RouterService::initialize \
        :router => router, \
        :ctx => { :port => Settings::PORT_NUMBER }

      Application::RouterService::run!
    end

    # Starting a node.
    def Util::run_as_node cfg
      node = Domain::ComponentFactory::instance.create_node \
        :parent => cfg.parent,
        :repo_uri => Util::generate_repo_uri(cfg.repository_name),
        :name => cfg.name,
        :managed => cfg.managed?,
        :confidentiality_strategy => cfg.confidentiality_strategy
      Application::NodeService::initialize \
        :node => node, 
        :ctx => { :port => Settings::PORT_NUMBER }

      Application::NodeService::run!
    end

    # Starting a peer node.
    def Util::run_as_peer_node

    end

    # Starting a context server.
    def Util::run_as_context_server
      filename = "#{File.dirname __FILE__}/../../etc/1_2_2_initial_context.rb"
      Application::ContextManagerService::initialize \
        :initial_context_file => filename,
        :ctx => { :port => Settings::CONTEXT_PORT_NUMBER }

      Application::ContextManagerService::run!
    end

    # Reading and returning an object from an S3 bucket.
    # This uses SSL for encryption, but does not verify
    # the endpoints.
    def Util::read_object_from_s3 uri
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
    end

    # Retreiving a repository from S3.
    # * The repository name
    def Util::generate_repo_uri repo_name
      return nil if repo_name == nil
      s3 = AWS::S3.new
      url = s3.buckets[:chrislambistan_repos] \
        .objects[repo_name] \
        .url_for :read
      url == nil ? url : URI::parse(url.to_s)
    end

    # Process an error from a network component.
    # * The object reporting the error
    # * The error message
    # * The exception
    def Util::process_error reporter, msg, err
      syslog = Domain::ComponentFactory::instance.create_system_log reporter.to_s
      syslog.error 'Node has crashed!'
      syslog.error err.to_s
      err.backtrace.each do |s|
        syslog.error "\t#{s}"
      end
    end

    def Util::build_name
      pub_addr  = \\
        Socket::ip_address_list.detect do |intf| 
          intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?
        end

      if pub_addr == nil
        az_public_ip = Net::HTTP.get_response(URI::parse('http://instance-data.ec2.internal/latest/meta-data/public-ipv4')).body
        Resolv.new.getname az_public_ip
      else
        pub_addr.ip_address
      end
    end

    def Util::build_remote_hostname ip_addr
      name = Resolv.new.getname ip_addr
      name =~ /amazon/ ? name : ip_addr
    end

    def Util::build_link_name lhs, rhs
      "#{lhs}_#{rhs}"
    end

  end

end

# Thes are utility classes.  They need to be included
# at the end of the file, after the module, as they
# include themselves within the Util module as a
# namespace.
require_relative 'util/policy_evaluator'
require_relative 'util/content_rectifier'