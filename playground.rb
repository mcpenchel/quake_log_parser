# Hi there! If you're wondering about this file, I've left it here
# just to document my way of thinking towards a solution: first I
# made sure the regex was OK for extracting the info that we needed
# and then I went to refactor the whole thing into classes and etc.

kill_expression = /^\s*\d+:\d{2}\sKill/
new_match_expression = /^\s*\d+:\d{2}\sInitGame/
user_connected_expression = /^\s*\d+:\d{2}\sClientUserinfoChanged/
get_username_expression = /^\s*\d+:\d{2}\sClientUserinfoChanged:\s\d+\s*n\\+(?<username>[^\\]+)/
kill_group_expression = /Kill:[\d\s]+:\s*(?<killer>.+) killed (?<victim>.+) by (?<death_cause>.+)/

match_count = 0
match_hash  = {}

File.open('qgames.log').each do |line|
  # Starting new match
  if line.match?(new_match_expression)
    match_count += 1

    match_hash["game_#{match_count}"] = {
      "total_kills" => 0,
      "players" => [],
      "kills" => {},
      "kills_by_means" => {}
    }
  end

  # Player connected
  if line.match?(user_connected_expression)
    username = line.match(get_username_expression)[:username]

    unless match_hash["game_#{match_count}"]["players"].include?(username)
      match_hash["game_#{match_count}"]["players"] << username
      match_hash["game_#{match_count}"]["kills"][username] = 0
    end
  end

  # Killing Spree
  if line.match?(kill_expression)
    match_hash["game_#{match_count}"]["total_kills"] += 1

    kill_data = line.match(kill_group_expression)

    if kill_data[:killer] == '<world>'
      match_hash["game_#{match_count}"]["kills"][kill_data[:victim]] -= 1
    else
      match_hash["game_#{match_count}"]["kills"][kill_data[:killer]] += 1
    end

    match_hash["game_#{match_count}"]["kills_by_means"][kill_data[:death_cause]] ||= 0
    match_hash["game_#{match_count}"]["kills_by_means"][kill_data[:death_cause]] += 1
  end

end

match_hash.each do |key, value|
  puts '####################################'
  puts key
  puts "Total Kills: #{value['total_kills']}"
  puts "Players: #{value['players'].join(', ')}\n"
  puts "Kills:\n"
  value['kills'].each do |username, kill_count|
    puts "    #{username}: #{kill_count}\n"
  end
  puts "Death causes:\n"
  value['kills_by_means'].each do |death_cause, kill_count|
    puts "    #{death_cause}: #{kill_count}\n"
  end
end

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
