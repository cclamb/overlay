require 'rspec'
require_relative '../../../lib/garden/util/policy_evaluator'

describe PolicyEvaluator do
	it 'should handle a simple policy' do
    evaluator = PolicyEvaluator.new(:one) do
      instance_eval(File.read('../../../etc/policies/policy_1.pol'))
    end
    evaluator.should_not eq nil
	end
end
