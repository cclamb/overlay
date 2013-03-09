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
require 'rspec'
require_relative '../../../lib/garden/util'

include Garden

describe Util::PolicyEvaluator do

  policy_1_suffix = 'etc/policies/policy_1.pol'
  policy_1 = nil
  base = ''

  before(:all) do
    while true do
      found = false
      begin
        File.open(base + policy_1_suffix) do
         found = true
        end
      rescue
        base = base + '../'
      end
      break if found == true
    end
  end

	it 'should handle a simple policy' do
    evaluator = Util::PolicyEvaluator.new(:one) do
      instance_eval(File.read(base + 'etc/policies/policy_1.pol'))
    end
    evaluator.should_not eq nil
	end

  it 'should handle a full policy' do
    evaluator = Util::PolicyEvaluator.new(:one) do
      instance_eval(File.read(base + 'etc/policies/policy_2.pol'))
    end
    evaluator.should_not eq nil
    evaluator.ctx[:p1].should_not eq nil
    evaluator.ctx[:p1][:style].should eq :all
    evaluator.ctx[:p1][:sensitivity].should_not eq nil
    evaluator.ctx[:p2].should_not eq nil
    evaluator.ctx[:p2][:style].should eq :all
    evaluator.ctx[:p2][:sensitivity].should_not eq nil
    evaluator.ctx[:p2][:device].should_not eq nil
    evaluator.ctx[:p3].should_not eq nil
    evaluator.ctx[:p3][:style].should eq :one
    evaluator.ctx[:p3][:sensitivity].should_not eq nil
    evaluator.ctx[:p3][:organization].should_not eq nil
  end
end
