require_relative '../models/kill'
require_relative '../models/match'

class LogToMatchesService
  attr_reader :matches

  NEW_MATCH = /^\s*\d+:\d{2}\sInitGame/
  PLAYER_KILLED = /Kill:[\d\s]+:\s*(?<killer>.+) killed (?<victim>.+) by (?<death_cause>.+)/
  PLAYER_CONNECTED = /^\s*\d+:\d{2}\sClientUserinfoChanged:\s\d+\s*n\\+(?<player>[^\\]+)/

  def initialize(file_name)
    @file_name = file_name
    @matches   = []
  end

  def call
    match = nil

    File.open(@file_name).each do |line|
      if line.match?(NEW_MATCH)
        match = Match.new
        @matches << match
      end

      if line.match(PLAYER_CONNECTED)
        player = line.match(PLAYER_CONNECTED)[:player]

        match.connect_player(player)
      end

      if line.match(PLAYER_KILLED)
        data = line.match(PLAYER_KILLED)

        kill = Kill.new(
          killer: data[:killer],
          victim: data[:victim],
          death_cause: data[:death_cause]
        )

        match.register_kill(kill)
      end
    end
  end
end