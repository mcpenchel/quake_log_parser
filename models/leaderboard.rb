class Leaderboard
  attr_reader :results

  def initialize(match)
    @match = match
    @results = {}

    calculate
  end

  def self.all_time(leaderboards)
    results = Hash.new(0)
    
    leaderboards.each { |board| board.results.each { |key, count| results[key] += count } }

    results
  end

  def calculate
    raise 'NotImplemented'
  end
end