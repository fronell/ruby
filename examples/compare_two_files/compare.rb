file1 = 'list1.txt'
file2 = 'list2.txt'

# Reading the contents into arrays will be easiest for comparison
l1 = File.open(file1).read.split("\n")
l2 = File.open(file2).read.split("\n")

puts "list1 values: #{l1}"
puts "list2 values: #{l2}"
# & is the intersection operator and returns the intersected array
puts "common values: #{(l1 & l2)}"
puts "list1 unique values: #{l1 - l2}"
puts "list2 unique values: #{l2 - l1}"
