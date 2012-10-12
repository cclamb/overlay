require_relative '../../garden'

class Garden::Util::ContentRectifier

  def initialize params
    @umm = params[:umm]
    @context_mgr = params[:context_manager]
    @syslog = Domain::ComponentFactory::instance.create_system_log self
    @strategy = params[:confidentiality_strategy] || :redact
  end

  def process args
    @syslog.info "processing content: #{args[:artifact]}"
    components = Util::parse_response args[:artifact]
    return components[:artifact] if components[:policy] == nil
    #TODO: you *must* reform the results into a valid document to be passed on!
    args[:artifact]
  end

	def encrypt

  end

  def redact

  end

  def reroute

  end
end

class Garden::Util::NilContentRectifier
  def process args
    args[:artifact]
  end
end