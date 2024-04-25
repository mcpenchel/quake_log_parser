class Kill
  attr_reader :death_cause

  def initialize(attributes = {})
    @killer = attributes[:killer]
    @victim = attributes[:victim]
    @death_cause = attributes[:death_cause]
  end

  def killed_by_environment?
    @killer == '<world>'
  end

  def user_for_leaderboard
    killed_by_environment? ? @victim : @killer
  end

  def count_for_leaderboard
    killed_by_environment? ? -1 : 1
  end
end