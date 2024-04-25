# frozen_string_literal: true

require_relative 'services/log_to_matches_service'
require_relative 'models/player_leaderboard'
require_relative 'models/death_leaderboard'
require_relative 'lib/utils'

service = LogToMatchesService.new('data/qgames.log')
service.call

leaderboards = []
deathboards  = []

service.matches.each_with_index do |match, index|
  puts '############################'
  puts "MATCH #{index + 1}:"
  puts "Total kills: #{match.kills.size}"
  puts "Players: #{match.players.sort.join(', ')}"

  puts 'Kills:'
  leaderboard = PlayerLeaderboard.new(match)
  leaderboards << leaderboard

  sorted_results = sort_hash(leaderboard.results)
  print_hash(sorted_results)

  puts 'Causes of death:'
  deathboard = DeathLeaderboard.new(match)
  deathboards << deathboard

  sorted_results = sort_hash(deathboard.results)
  print_hash(sorted_results)
end

puts '############################'
puts 'All-Time Kills:'
all_time_leaderboard = PlayerLeaderboard.all_time(leaderboards)
sorted_score = sort_hash(all_time_leaderboard)
print_hash(sorted_score)

puts '############################'
puts 'All-Time Causes of death:'
all_time_deathboard = DeathLeaderboard.all_time(deathboards)
sorted_score = sort_hash(all_time_deathboard)
print_hash(sorted_score)
