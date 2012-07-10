require 'aws-sdk'
require 'socket'
require 'logging'

require_relative 's_3'

class LogFactory

  def initialize bucket_name
    raise 'must have valid S3 bucket name' if bucket_name == nil
    hostname = Socket.gethostname
    appender = Logging.appenders.s3 \
      :level => :debug, \
      :layout => Logging.layouts.yaml(:format_as => :yaml), \
      :source => Socket::gethostname, \
      :bucket_name => bucket_name
    file_appender = Logging.appenders.file \
      'system.log', \
      :level => :debug
  end

  def create_system_log requestor
    hostname = Socket.gethostname
    log = Logging.logger["[#{hostname}] #{requestor}"]
    log.add_appenders 'system.log'
    log
  end

  def create_overlay_log requestor
    log = Logging.logger[requestor]
    log.add_appenders 's3'
    log
  end

end