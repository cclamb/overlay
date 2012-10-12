

class Garden::Domain::ContextManager
  
	def context
    { 
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
	end

end