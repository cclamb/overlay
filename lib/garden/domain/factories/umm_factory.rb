require_relative '../usage_management_mechanism'

include Garden

class Garden::Domain::Factories::UmmFactory
  def create_umm
    Domain::UsageManagementMechanism.new
  end
end