require_relative 'leaderboard'

class DeathLeaderboard < Leaderboard
  private
  def calculate
    @match.kills.each do |kill|
      @results[kill.death_cause] ||= 0
      @results[kill.death_cause] += 1
    end
  end
end