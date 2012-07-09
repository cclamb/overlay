
require 'logging'
require 'socket'

# Various utility methods used in the system.  This is
# essentially a factor module for various components that
# require similar configuration and are used globaly.
module Util

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

  # Create, configure, and return a logger for *overlay state*.
  def Util::overlay_logger requestor
    log = Logging.logger[requestor]
    log.add_appenders 's3'
    log
  end

  # Create, configura, and return a logger for *system state*.
  def Util::system_logger requestor
    hostname = Socket.gethostname
    log = Logging.logger["[#{hostname}] #{requestor}"]
    log.add_appenders 'system.log'
    log
  end

end