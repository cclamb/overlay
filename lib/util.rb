
require 'logging'
require 'socket'
require 'uri'

require_relative 'configuration_repository'

# Various utility methods used in the system.  This is
# essentially a factor module for various components that
# require similar configuration and are used globaly.
module Util

  # # Configuring loggers.  Here, we configure both the global
  # # overlay logger and the local system logger.  We access
  # # these loggers via methods in the Util module.
  # def Util::configure_logging args
  #   hostname = Socket.gethostname
  #   appender = Logging.appenders.s3 \
  #     :level => :debug, \
  #     :layout => Logging.layouts.yaml(:format_as => :yaml), \
  #     :source => Socket::gethostname, \
  #     :bucket_name => args[:bucket_name]
  #   file_appender = Logging.appenders.file \
  #     'system.log', \
  #     :level => :debug
  # end

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

end