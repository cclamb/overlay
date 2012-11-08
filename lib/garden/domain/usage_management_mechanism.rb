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