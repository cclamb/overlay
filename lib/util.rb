
require 'logging'
require 'socket'

# Various utility methods used in the system.  This is
# essentially a factor module for various components that
# require similar configuration and are used globaly.
module Util

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