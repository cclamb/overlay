require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

Policy_Tropic_Thunder =<<EOF
policy_set {
	policy(:default) {
		rule(:mission_affiliation) { |ma| ma == :tropic_thunder}
	}
}
EOF

Policy_Inherited =<<EOF
policy_set {
  policy(:default) {
    rule(:mission_affiliation) { |ma| ma == :tropic_thunder }
  }
  policy(:description) {
    include :default
    rule(:category) { |c| c == :chartruce }
    rule(:sensitivity) { |s| s == :top_secret || s == :secret }
  }
  policy(:history) {
    include :default
    rule(:category) { |c| c == :magenta }
    rule(:sensitivity) { |s| s == :top_secret }
  }
  policy(:location) {
    include :default
    rule(:category) { |c| c == :vermillion }
    rule(:sensitivity) { |s| s == :top_secret || s == :secret || s == :unclassified }
  }
}
EOF

Base_Context = { 
	:link => {
		:sensitivity => :secret,
		:category => :magenta,
		:organization => :eurasia,
		:mission_affiliation => :tropic_thunder
	},
	:user => {
		:clearance => :top_secret,
		:category => :magenta,
		:organziation => :oceania,
		:mission_affiliation => :tropic_thunder,
		:device => :tablet
	}
}

describe UsageManagementMechanism do

	umm = UsageManagementMechanism.new

  it 'should pass with a matching affiliation' do
    evaluator = Util::PolicyEvaluator.new(:one) do
      instance_eval(Policy_Tropic_Thunder)
    end
    policy = evaluator.ctx[:default]
    umm.execute?(policy, Base_Context[:link], :transmit).should eq true
    umm.execute?(policy, Base_Context[:user], :transmit).should eq true
  end

  it 'should fail with an affiliation mis-match' do
    evaluator = Util::PolicyEvaluator.new(:one) do
      instance_eval(Policy_Tropic_Thunder)
    end
    policy = evaluator.ctx[:default]
  	test_link = Base_Context[:link].clone
  	test_link[:mission_affiliation] = :silent_ninja
  	umm.execute?(policy, test_link, :transmit).should eq false
  end

  it 'should handle larger policies' do
    evaluator = Util::PolicyEvaluator.new(:one) do
      instance_eval(Policy_Inherited)
    end
    [:default, :description, :history, :location].each do |policy_name|
      policy = evaluator.ctx[policy_name]
      case policy_name
      when :default
        umm.execute?(policy, Base_Context[:link], :transmit).should eq true
        umm.execute?(policy, Base_Context[:user], :transmit).should eq true
      when :description
        umm.execute?(policy, Base_Context[:link], :transmit).should eq false
        umm.execute?(policy, Base_Context[:user], :transmit).should eq false
      when :history
        umm.execute?(policy, Base_Context[:link], :transmit).should eq false
        umm.execute?(policy, Base_Context[:user], :transmit).should eq true
      when :location
        umm.execute?(policy, Base_Context[:link], :transmit).should eq false
        umm.execute?(policy, Base_Context[:user], :transmit).should eq false
      else
        fail 'unknown tag'
      end
        
    end
  end

end