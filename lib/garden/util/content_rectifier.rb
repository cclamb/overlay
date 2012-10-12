require_relative '../../garden'

class Garden::Util::ContentRectifier

  def initialize params
    @umm = params[:umm]
    @context_mgr = params[:context_manager]
    @syslog = Domain::ComponentFactory::instance.create_system_log self
    @strategy = params[:confidentiality_strategy] || :redact
  end

  def process args
    #components = Util::parse_response args[:artifact]
    #return components[:artifact] if components[:policy] == nil

    doc = Nokogiri::XML args[:artifact]
    policy_set = doc.xpath '//artifact/policy-set'

    return args[:artifact] if policy_set == nil

    #data_object = doc.xpath '//artifact/data-object'
    sections = doc.xpath '//artifact/data-object/content/section'

    evaluator = Util::PolicyEvaluator.new do
      instance_eval(policy_set[0].content.to_s)
    end

    sections.each do |section|
      policy_name = section.attr 'policy'
      puts "PN: #{policy_name}"
      #puts check_set(failed_sections, policy_name)
      section.remove if @umm.execute? \
      evaluator.ctx[policy_name.to_sym], \
      @context_mgr.context, \
      :transmit # check_set(failed_sections, policy_name)
    end


    #TODO: you *must* reform the results into a valid document to be passed on!
    #args[:artifact]
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