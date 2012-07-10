

class ComponentFactory

	def initialize values
		@log_factory = LogFactory.new values[:bucket_name]
	end

	def create_system_log requestor
		@log_factory.create_system_log requestor
	end

	def create_overlay_log requestor
		@log_factory.create_overlay_log requestor
	end

end