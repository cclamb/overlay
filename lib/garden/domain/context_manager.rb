

class Garden::Domain::ContextManager

	def context
    { 
      :link => {
        :sensitivity => :secret,
        :category => :magenta,
        :organization => :eurasia,
        :mission_affiliation => :flying_shrub
      },
      :user => {
        :clearance => :top_secret,
        :category => :magenta,
        :organziation => :oceania,
        :mission_affiliation => :parched_iguana,
        :device => :tablet
      }
    }
	end

end