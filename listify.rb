def listy
  all_lines = File.readlines("list.txt").each {|l| l.chomp!}
  new_array = []
  all_lines.each do |a|
    b = a.strip
    b.prepend("- ")
    unless(b == "- ")
      new_array.push(b)
    end
  end
  
  File.open("new_list.txt", "w") do |line|
    new_array.each do |a|
      line.puts(a)
    end
  end
end

listy