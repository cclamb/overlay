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
require 'net/https'
require 'uri'
require 'yaml'
require 'socket'

# This is the respository element that grabs and returns
# a simulation configuration.  The configuration is a
# YAML document in an S3 bucket, and the get_configuration(.)
# method will return a Ruby object containing the data.
class ConfigurationRepository
  
  # Initializing the configuration repository with a URI
  # of the S3 bucket containing the configuration 
  # information.
  def initialize repo_uri
    raise 'need valid config repo uri' if repo_uri == nil
    @repo_uri = repo_uri
  end

  # Calling into S3 to retrieve the network context.  This
  # does not require that the keys be set, but does require
  # a valid URL generated from S3 with the appropriate
  # embedded credentials via the *obj.url_for* method call.
  # This is generally done in the capistrano Capfile and then
  # passed into this system via a command line argument.
  # * hostname  The system hostname
  def get_configuration hostname = nil
    hostname = hostname || Socket::gethostname
    response = Util::read_object_from_s3 @repo_uri
    YAML::load(response.body)[hostname]
  end

end