# frozen_string_literal: true

# Class to model a match and it's connections to players and kills
class Match
  attr_reader :kills, :players

  def initialize
    @players = []
    @kills   = []
  end

  def connect_player(player_name)
    @players << player_name unless @players.include?(player_name)
  end

  def register_kill(kill)
    @kills << kill
  end
end
