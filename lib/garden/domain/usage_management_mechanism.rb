require_relative '../../garden'

class Garden::Domain::UsageManagementMechanism

  def initialize
    @syslog = Domain::ComponentFactory::instance.create_system_log self
  end

  def execute? rules, ctx = {}, activity = :transmit

    failed_sections = Set.new

    rules.each do |rule_name, rule|
      ctx_value = ctx[rule_name]
      if ctx_value != nil
        evaluation = rule.call ctx_value.to_sym
        failed_sections.add rule_name if evaluation == false
      end
    end

    failed_sections.empty? ? true : false
  end
end