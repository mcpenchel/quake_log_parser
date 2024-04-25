# frozen_string_literal: true

require_relative '../models/kill'
require_relative '../models/match'

# Service responsible for parsing the log into matches and it's kills
class LogToMatchesService
  attr_reader :matches

  NEW_MATCH = /^\s*\d+:\d{2}\sInitGame/.freeze
  PLAYER_KILLED = /Kill:[\d\s]+:\s*(?<killer>.+) killed (?<victim>.+) by (?<death_cause>.+)/.freeze
  PLAYER_CONNECTED = /^\s*\d+:\d{2}\sClientUserinfoChanged:\s\d+\s*n\\+(?<player>[^\\]+)/.freeze

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

      connect_player_to_match(line, match) if line.match(PLAYER_CONNECTED)

      next unless line.match(PLAYER_KILLED)

      register_kill_to_match(line, match)
    end
  end

  private

  def connect_player_to_match(line, match)
    player = line.match(PLAYER_CONNECTED)[:player]
    match.connect_player(player)
  end

  def register_kill_to_match(line, match)
    data = line.match(PLAYER_KILLED)

    kill = Kill.new(
      killer: data[:killer],
      victim: data[:victim],
      death_cause: data[:death_cause]
    )

    match.register_kill(kill)
  end
end
