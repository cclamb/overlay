require_relative 'configuration_repository'

# This is a facade for all repositories to limit coupling
# to specific repository classes.  We use a hierarchy
# of repositories behind this general repository object.
class DataRepository

  # Creating the repository with a hash of arguments emulating
  # a named argument list.  We currently require:
  # * :context_url The URL to the S3 managed context
  def initialize values
    uri = URI::parse values[:context_url]
    @configuration_repository = ConfigurationRepository.new uri
  end

  # Retrieving the active configuration.
  def get_configuration
    @configuration_repository.get_configuration
  end

end