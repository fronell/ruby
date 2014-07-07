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

def simple_matching(line)
  puts "BEGIN: #{__method__}"
  puts "The =~ operator will return the starting index position if there is a " \
       "match and nil if there is no match"
  puts "Is 'NEEDS REPAIR' in string?: #{/NEEDS REPAIR/ =~ line}"
  puts "Answer with operands switched: #{line =~ /NEEDS REPAIR/}"
  print "Is 'chicken' in string?: "
  puts "Nope" unless /chicken/ =~ line
  puts "END: #{__method__}"
end
              
def scan_method(line)
  puts "BEGIN: #{__method__}"
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
  puts "END: #{__method__}"
end

def match_method(line)
  puts "BEGIN: #{__method__}"
  match_regex = /(\d+)/i
  puts "match will match only the first instance of a regex and store it in a " \
       "match object.  Its important to note that a match object is not an " \
       "array and has its own methods and properties.  For example, if there " \
       "are no matches, the following line will fail: if match.size > 0" \
       "because the match object is nil instead of a zero length array"
  puts "match method: #{ line.match(match_regex).inspect }"
  puts "pre match: #{ line.match(match_regex).pre_match }"
  puts "post match: #{ line.match(match_regex).post_match }"
  
  # Using Match Method From Regex Object
  puts "An alternative is to call the match method on the regex instead of the " \
       "string like so"
  puts "#{ /(\d+)/.match(line).inspect }"
  
  # Named Capture Groups
  named_groups = line.match(/bucket=(?<bucket>[\w\/]+).*tsidx=(?<tsidx>\d+).*source-metadata=(?<source-metadata>\d+)/)
  puts "Named Capture Groups"
  puts "bucket=#{named_groups['bucket']}"
  puts "tsidx=#{named_groups['tsidx']}"
  puts "source-metadata=#{named_groups['source-metadata']}"
  puts "END: #{__method__}"
end

def string_substitution(line)
  puts "BEGIN: #{__method__}"
  puts "replacing with a string (use \\1, \\2 ... to refer to captures)"
  puts "123 456 789".gsub(/(\d+)/, '[\1]')
  puts "123 456 789".gsub(/(\d+)/, "[\\1]")
  puts "replacing using a block"
  puts "123 456 789".gsub(/(\d+)/) { |m| m.to_i * 2 }
  puts "123 456 789".gsub(/(\d+)/) { $1.to_i * 2 }
  puts "END: #{__method__}"
end

def capturing_with_default_variables(line)
  puts "BEGIN: #{__method__}"
  line =~ /db_(\d+)_(\d+)/i
  puts "matching using the $n default variable"
  puts "$1=#{ $1 } $2=#{ $2 }"

  # When named capture groups are used with a literal regexp on the left-hand 
  # side of an expression and the =~ operator, the captured text is also 
  # assigned to local variables with corresponding names.
  /bucket=(?<bucket>[\w\/]+).*tsidx=(?<tsidx>\d+).*source-metadata=(?<source-metadata>\d+)/ =~ line
  puts "bucket=#{bucket}"
  puts "tsidx=#{tsidx}"
  # Not sure how source-metadata gets assigned because the '-' is an invalid
  # character for variable names
  #puts "source-metadata=#{source-metadata}"
  puts "END: #{__method__}"
end

def regex_delimiter(line)
  #If you're creating a regex literal that contains a /, you can do the following
  #so you don't have to escape it
  #normal way with a /
  regex = /bucket=(.*\/db_(\d+)_(\d+)_\d+)/i
  #new way that changes the delimiter to {}
  regex = %r{bucket=(.*/db_(\d+)_(\d+)_\d+)}i
end

def regex_object_matching(line)
  puts "BEGIN: #{__method__}"
  #The following will create a regex object which has its own methods for matching
  #You will want to go this route if there is a specific regex method you want
  #to take advantage of such as creating a hash from regex matches
  #http://www.ruby-doc.org/core-1.8.7/Regexp.html
  #r1 = Regexp.new('\d+') #=> /\d+/
  r2 = Regexp.new('(\d+)', true) #=> /\d+/i
  
  puts "match using pre-compiled regex object: #{ r2.match(line).inspect }"
  #This is the same thing except the regex isn't stored in a variable
  puts "match using string literal as regex object: #{ /(\d+)/i.match(line).inspect }"
  puts "END: #{__method__}"
end

simple_matching(line)
scan_method(line)
match_method(line)
string_substitution(line)
capturing_with_default_variables(line)
regex_object_matching(line)
