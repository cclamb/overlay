require_relative '../../garden'

class ContentRectifier

  def initialize params
    @umm = params[:umm]
    @context_mgr = params[:context_manager]
    @syslog = Domain::ComponentFactory::instance.create_system_log self
  end

  def process args
    @syslog.info "processing content: #{args[:artifact]}"
  end

	def encrypt

  end

  def redact

  end

  def reroute

  end
end