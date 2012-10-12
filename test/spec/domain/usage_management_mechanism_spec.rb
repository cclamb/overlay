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

  it 'test1' do
    umm.execute?(Policy_Tropic_Thunder, Base_Context, :transmit).should eq true
  end

end