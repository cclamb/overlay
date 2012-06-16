
require 'logging'
require 'socket'

module Util

  def Util::overlay_logger requestor
    log = Logging.logger[requestor]
    log.add_appenders 's3'
    log
  end

  def Util::system_logger requestor
    hostname = Socket.gethostname
    log = Logging.logger["[#{hostname}] requestor"]
    log.add_appenders 'system.log'
    log
  end

end