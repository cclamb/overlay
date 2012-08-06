
require 'logging'
require 'socket'
require 'uri'

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

    def Util::start cfg
      if cfg.is_router?
        Util::run_as_router
      elsif cfg.is_node?
        Util::run_as_node
      elsif cfg.is_peer_node?
        Util::run_as_peer_node
      else
        syslog.error 'A run type was not submitted in the context'
      end
    end

  end

end