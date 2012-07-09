require 'socket'
require 'aws-sdk'
require 'logging'
require 'net/https'
require 'uri'
require 'yaml'

require_relative '../lib/s_3'

# This module contains methods used to initially configure the
# operational environment.  This includes things like command
# line processing, setting keys for amazon, and other
# bootstrapping actions.
module Main

  # Configuring the AWS-SDK with access and secret keys.
  def Main::configure_aws args
    raise 'secret key is nil' if args[:secret_key] == nil
    raise 'access key is nil' if args[:access_key] == nil
    AWS.config \
      :access_key_id => args[:access_key], \
      :secret_access_key => args[:secret_key]
  end

  # Configuring loggers.  Here, we configure both the global
  # overlay logger and the local system logger.  We access
  # these loggers via methods in the Util module.
  def Main::configure_logging args
    hostname = Socket.gethostname
    appender = Logging.appenders.s3 \
      :level => :debug, \
      :layout => Logging.layouts.yaml(:format_as => :yaml), \
      :source => Socket::gethostname, \
      :bucket_name => args[:bucket_name]
    file_appender = Logging.appenders.file \
      'system.log', \
      :level => :debug
  end

end