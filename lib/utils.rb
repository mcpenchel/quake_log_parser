def sort_hash(hash)
  hash.sort_by { |key, count| count }.reverse.to_h
end

def print_hash(hash)
  hash.each do |key, count|
    puts "    #{key}: #{count}"
  end
end