
class Garden::Util::PolicyEvaluator

  attr_accessor :ctx
  attr_accessor :active_policy

  def initialize name = 'default', &body
    ctx = {:name => name, :strategy => :all, :rules => []}
    self.ctx = {}
    instance_exec &body
  end

  def policy_set name = nil, &body
    instance_exec &body
  end

  def policy name, &body
    self.active_policy = {}
    instance_exec &body
    self.ctx[name] = self.active_policy
  end

  def include name
    rules = self.ctx[name]
    raise 'undefined referenced policy' if rules == nil
    self.active_policy = self.active_policy.merge rules
  end

  def match style
    self.active_policy[:style] = style
  end

  def rule name, &body
    self.active_policy[name] = body
  end

end