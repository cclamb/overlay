require 'rspec'
require_relative '../../../lib/garden/util/policy_evaluator'

describe PolicyEvaluator do

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
    evaluator = PolicyEvaluator.new(:one) do
      instance_eval(File.read(base + 'etc/policies/policy_1.pol'))
    end
    evaluator.should_not eq nil
	end

  it 'should handle a full policy' do
    evaluator = PolicyEvaluator.new(:one) do
      instance_eval(File.read(base + 'etc/policies/policy_2.pol'))
    end
    puts evaluator.ctx.to_s
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
