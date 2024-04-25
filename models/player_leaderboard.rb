# frozen_string_literal: true

require_relative 'leaderboard'

# Class that calculates how many kills per player
class PlayerLeaderboard < Leaderboard
  private

  def calculate
    @match.players.each { |player| @results[player] = 0 }
    @match.kills.each   { |kill| @results[kill.user_for_leaderboard] += kill.count_for_leaderboard }
  end
end
