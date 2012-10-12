require_relative '../../garden'

class Garden::Util::ContentRectifier

  def initialize params
    @umm = params[:umm]
    @syslog = Domain::ComponentFactory::instance.create_system_log self
    @strategy = params[:confidentiality_strategy] || :redact
  end

  def process args
    doc = Nokogiri::XML args[:artifact]
    policy_set = doc.xpath '//artifact/policy-set'

    return args[:artifact] if policy_set == nil

    sections = doc.xpath '//artifact/data-object/content/section'

    evaluator = Util::PolicyEvaluator.new do
      instance_eval(policy_set[0].content.to_s)
    end

    sections.each do |section|
      policy_name = section.attr 'policy'
      @syslog.info "policy: #{policy_name} \n context: #{args[:context]}"
      section.remove unless @umm.execute? evaluator.ctx[policy_name.to_sym], args[:context], :transmit
    end
    doc.to_s
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