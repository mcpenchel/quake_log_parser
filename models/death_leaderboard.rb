# frozen_string_literal: true

require_relative 'leaderboard'

# Class that calculates how many deaths per death cause
class DeathLeaderboard < Leaderboard
  private

  def calculate
    @match.kills.each do |kill|
      @results[kill.death_cause] ||= 0
      @results[kill.death_cause] += 1
    end
  end
end
