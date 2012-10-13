require 'mail'

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
    #@syslog.info "policy set: #{policy_set.to_s}"
    return args[:artifact] if policy_set == nil

    sections = doc.xpath '//artifact/data-object/content/section'

    evaluator = Util::PolicyEvaluator.new do
      instance_eval(policy_set[0].content.to_s)
    end

    #@syslog.info "evaluator: #{evaluator.ctx.inspect}"
    sections.each do |section|
      policy_name = section.attr 'policy'
      #@syslog.info "policy: #{policy_name} \n context: #{args[:context]}"
      if @strategy == :redact
        section.remove unless @umm.execute? evaluator.ctx[policy_name.to_sym], args[:context], :transmit
      elsif @strategy == :reroute
        unless @umm.execute? evaluator.ctx[policy_name.to_sym], args[:context], :transmit 

          # options = {
          #   :address              => 'smtp.gmail.com',
          #   :user_name            => 'chrislambistan',
          #   :password             => 'ab212719',
          #   :enable_starttls_auto => true
          # }

          # Mail.defaults do
          #   delivery_method :smtp, options
          # end

          # mail = Mail.new do
          #   from     'cclamb@ece.unm.edu'
          #   to       'chrislambistan@gmail.com'
          #   subject  'Rerouted Content'
          #   body     section.to_s
          # end

          # @syslog.info "beginning mail delivery..."
          # begin
          #   mail.deliver!
          # rescue RuntimeError => err
          #   @syslog.info "error thrown in rectifier: #{err}"
          # end

          section.remove

        end
      end
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
    # Domain::ComponentFactory::instance.create_system_log(self).info '...in NilContentRectifier...'
    args[:artifact]
  end
end