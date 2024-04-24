kill_expression = /^\s*\d+:\d{2}\sKill/
new_match_expression = /^\s*\d+:\d{2}\sInitGame/
user_connected_expression = /^\s*\d+:\d{2}\sClientUserinfoChanged/
get_username_expression = /^\s*\d+:\d{2}\sClientUserinfoChanged:\s\d+\s*n\\+(?<username>[^\\]+)/

kill_count = 0
match_count = 0
players = []

File.open('qgames.log').each do |line|
  puts line

  match_count += 1 if line.match?(new_match_expression)
  kill_count += 1 if line.match?(kill_expression)

  players << line.match(get_username_expression)[:username] if line.match?(user_connected_expression)
end

puts "\n\n Total kill count: #{kill_count}"
puts "\n Number of matches: #{match_count}"
puts "\n Players: #{players.uniq.join(', ')}"

# Desired output per match:
#
# "game_1": {
#   "total_kills": 45,
#   "players": ["Dono da bola", "Isgalamido", "Zeh"],
#   "kills": {
#     "Dono da bola": 5,
#     "Isgalamido": 18,
#     "Zeh": 20
#     }
# }
#
# Rules to consider:
# 1. When <world> kill a player, that player loses -1 kill score.
# 2. Since <world> is not a player, it should not appear in the list of players or in the dictionary of kills.
# 3. The counter total_kills includes player and world deaths.
