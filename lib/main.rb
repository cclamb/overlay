
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

  # Process the arguments on the command line.  We expect the
  # order to be:
  # * The URL of the configuration document generated from S3
  # * The S3 access key
  # * The S3 secret key
  # * The S3 location to log overlay specific operational state
  def Main::process_args args
    {:context_url => args[0], \
      :access_key => args[1], \
      :secret_key => args[2], \
      :bucket_name => args[3] }
  end

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

  # Calling into S3 to retrieve the network context.  This
  # does not require that the keys be set, but does require
  # a valid URL generated from S3 with the appropriate
  # embedded credentials via the *obj.url_for* method call.
  # This is generally done in the capistrano Capfile and then
  # passed into this system via a command line argument.
  def  Main::load_ctx args
    url = args[:context_url]
    uri = URI.parse url
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new uri.request_uri
    response = http.request request
    YAML::load response.body
  end

end