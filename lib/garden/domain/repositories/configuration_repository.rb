require 'net/https'
require 'uri'
require 'yaml'
require 'socket'

require_relative '../component_factory'

include Garden

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
    @syslog = Domain::ComponentFactory::instance \
      .create_system_log self
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
    @syslog.info "hostname: |#{hostname}|"
    @syslog.info "Configuration Returned: #{response.body}"
    YAML::load(response.body)[hostname]
  end

end