
class PolicyEvaluator

  attr_accessor :ctx

  def initialize name, &body
    ctx = {:name => name, :strategy => :all, :rules => []}
    instance_exec(&body)
  end

  def policy_set

  end

  def policy name, &body

  end

  def include

  end

  def match

  end

  def rule name, &body

  end

  # def activity(name, &b)
  #   activity = Activity.new(name, &b)
  #   @activities[name] = activity
  #   activity
  # end

  # def constraint(&b)
  #   Constraint.new(&b)
  # end

  # def restrict(*activities, &b)
  #   restriction = Restrict.new(activities, &b)
  #   @restrictions.push(restriction)
  #   restriction
  # end

  # def policy(&b)
  #   policy = Policy.new(&b)
  #   @policies.push(policy)
  #   policy    
  # end

  # def context
  #   PolicyContext.new(@activities, @restrictions, @policies)
  # end

end