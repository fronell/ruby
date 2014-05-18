#Reference: http://www.tutorialspoint.com/ruby/ruby_regular_expressions.htm

#The following uses regex methods associated with string objects
#named capturing is not supported in Ruby 1.8, only 1.9
#The following modifiers may be used with regex literals
=begin
/.*/i Ignore case when matching text.
/.*/o Perform #{} interpolations only once, the first time the regexp literal is evaluated.
/.*/x Ignores whitespace and allows comments in regular expressions
/.*/m Matches multiple lines, recognizing newlines as normal characters
/.*/u,e,s,n Interpret the regexp as Unicode (UTF-8), EUC, SJIS, or ASCII. If none of these modifiers is specified, the regular expression is assumed to use the source encoding.  
=end
line = 'bucket=/opt/splunk/var/lib/splunk/audit/db/db_1343024430_1343019876_77' \
       ' NEEDS REPAIR: count mismatch tsidx=214 source-metadata=199'
              
scan_regex = /\d+/i
puts scan_regex
puts scan_regex.source
puts "scan will match all instances of the regex, not just the first and " \
     "store the results within an array.  If capturing ()'s are used, then " \
     "scan will create an array of arrays.  This means matches will " \
     "have to be accessed using something like matches[0][match_index]"       
puts "scan method without ()'s: #{ line.scan(scan_regex).inspect }"
scan_regex = /(\d+)/i
puts "scan method with ()'s: #{ line.scan(scan_regex).inspect }"

puts "scan also be used in a block expression"
line.scan(scan_regex) { |m| puts m }

match_regex = /(\d+)/i
puts "match will match only the first instance of a regex and store it in a " \
     "match object.  Its important to note that a match object is not an " \
     "array and has its own methods and properties.  For example, if there " \
     "are no matches, the following line will fail: if match.size > 0" \
     "because the match object is nil instead of a zero length array"
puts "match method: #{ line.match(match_regex).inspect }"
puts "pre match: #{ line.match(match_regex).pre_match }"
puts "post match: #{ line.match(match_regex).post_match }"

#Replacing strings using regex
puts "replacing with a string (use \\1, \\2 ... to refer to captures)"
puts "123 456 789".gsub(/(\d+)/, '[\1]')
puts "123 456 789".gsub(/(\d+)/, "[\\1]")
puts "replacing using a block"
puts "123 456 789".gsub(/(\d+)/) { |m| m.to_i * 2 }
puts "123 456 789".gsub(/(\d+)/) { $1.to_i * 2 }

#Matching using the default $n variables
line =~ /db_(\d+)_(\d+)/i
puts "matching using the $n default variable"
puts "$1=#{ $1 } $2=#{ $2 }"

#Variable substitution for regex strings is allowed
regex = '\d+'
puts "match method with variable substitution: #{line.match(/#{ regex }/i).inspect}"

#If you're creating a regex literal that contains a /, you can do the following
#so you don't have to escape it
#normal way with a /
regex = /bucket=(.*\/db_(\d+)_(\d+)_\d+)/i
#new way that changes the delimiter to <>
regex = %r<bucket=(.*/db_(\d+)_(\d+)_\d+)>i

#The following will create a regex object which has its own methods for matching
#You will want to go this route if there is a specific regex method you want
#to take advantage of such as creating a has from regex matches
#http://www.ruby-doc.org/core-1.8.7/Regexp.html
r1 = Regexp.new('\d+') #=> /\d+/
r2 = Regexp.new('(\d+)', true) #=> /\d+/i

puts "match using pre-compiled regex object: #{ r2.match(line).inspect }"
#This is the same thing except the regex isn't stored in a variable
puts "match using string literal as regex object: #{ /(\d+)/i.match(line).inspect }"
