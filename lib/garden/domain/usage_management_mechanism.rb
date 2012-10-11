require_relative '../../garden'

class Garden::Domain::UsageManagementMechanism

  def initialize
    @syslog = Domain::ComponentFactory::instance.create_system_log self
  end

  def execute? policy, ctx, activity
    @syslog.info "Retrieved policy: #{policy}"
    if activity == :transmit
    end
  end
end