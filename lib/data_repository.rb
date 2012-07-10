require_relative 'configuration_repository'

class DataRepository

  def initialize values
    uri = URI::parse values[:context_url]
    @configuration_repository = ConfigurationRepository.new uri
  end

  def get_configuration
    @configuration_repository.get_configuration
  end

end