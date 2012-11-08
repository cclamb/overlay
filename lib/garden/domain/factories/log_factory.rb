#--
# Copyright (c) 2012 Christopher C. Lamb
#
# SBIR DATA RIGHTS
# Contract No. FA8750-11-C-0195
# Contractor: AHS Engineering Services (under subcontract to Modus Operandi, Inc.)
# Address: 5909 Canyon Creek Drive NE, Albuquerque, NM 87111
# Expiration Date: 05/03/2018
# 
# The Government’s rights to use, modify, reproduce, release, perform, display, 
# or disclose technical data or computer software marked with this legend are 
# restricted during the period shown as provided in paragraph (b) (4) 
# of the Rights in Noncommercial Technical Data and Computer Software-Small 
# Business Innovative Research (SBIR) Program clause contained in the above 
# identified contract. No restrictions apply after the expiration date shown 
# above. Any reproduction of technical data, computer software, or portions 
# thereof marked with this legend must also reproduce the markings.
#++
require 'aws-sdk'
require 'socket'
require 'logging'

require_relative '../../util/s_3'

# A log factory is responsible for assembling loggers, both
# local and distributed.
class Garden::Domain::Factories::LogFactory

  # We initialize the factory with the name of the bucket
  # to use for distributed logging.  This could potentially
  # be done such that the bucket name is submitted on creation,
  # allowing for creation of multiple arbitrary logs, where
  # each log is keyed by the bucket name, but that's advanced
  # functionality we don't need at this point.  You could
  # take the same approach for local logs as well.
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

  # Creating the system log and returning.
  def create_system_log requestor
    hostname = Socket.gethostname
    log = Logging.logger["[#{hostname}] #{requestor}"]
    log.add_appenders 'system.log'
  end

  # Creating a distributed log handle.
  def create_overlay_log requestor
    log = Logging.logger[requestor]
    log.add_appenders 's3'
  end

end