
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
  def Main::process_args
    {:context_url => ARGF.argv[0], \
      :access_key => ARGF.argv[1], \
      :secret_key => ARGF.argv[2], \
      :bucket_name => ARGF.argv[3] }
  end

  # Configuring the AWS-SDK with access and secret keys.
  def Main::configure_aws arguments
    AWS.config \
      :access_key_id => arguments[:access_key], \
      :secret_access_key => arguments[:secret_key]
  end

  # Configuring loggers.  Here, we configure both the global
  # overlay logger and the local system logger.  We access
  # these loggers via methods in the Util module.
  def Main::configure_logging arguments
    hostname = Socket.gethostname
    appender = Logging.appenders.s3 \
      :level => :debug, \
      :layout => Logging.layouts.yaml(:format_as => :yaml), \
      :source => Socket::gethostname, \
      :bucket_name => arguments[:bucket_name]
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
  def  Main::load_ctx arguments
    url = arguments[:context_url]
    uri = URI.parse url
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new uri.request_uri
    response = http.request request
    YAML::load response.body
  end

end