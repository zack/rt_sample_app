require "awesome_print"

input = []
counts = []
words = []

File.open("input.txt", "r") do |f|
  f.each_line do |line|
    input << line
    counts << [0, line.length-1]
  end
end

temp = []
input.each_with_index do |item, index|
  temp << item[counts[index][0]]
end
words << temp.join("")

ap words
