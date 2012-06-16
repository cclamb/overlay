
require 'socket'
require 'aws-sdk'
require 'logging'
require 'net/https'
require 'uri'
require 'yaml'

require_relative '../lib/s_3'

module Main

  def Main::process_args
    {:context_url => ARGF.argv[0], \
      :access_key => ARGF.argv[1], \
      :secret_key => ARGF.argv[2], \
      :bucket_name => ARGF.argv[3] }
  end

  def Main::configure_aws arguments
    AWS.config \
      :access_key_id => arguments[:access_key], \
      :secret_access_key => arguments[:secret_key]
  end

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