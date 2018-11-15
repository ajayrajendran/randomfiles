def x
  hash = {
    a: {
      aa: "aa",
      ab: "ab"
    },
    b: {
      ba: "ba",
      bb: "bb"
      
    },
    c: {
      ca: "ca",
      cb: "cb"
      
    }
  }
  counter = 0
  hash.each do |key, next_key|
    next_key.each do |key_next, val|
      val = counter
      hash[key][key_next] = val
      counter += 1
    end
  end
  puts hash
end

def time 
  (Date.today - 180).upto(Date.today).each_with_index do |date, idx|
    puts date
    puts idx
  end
end

time