# References:
# http://rakeroutes.com/blog/parsing-dates-and-times-from-strings/
# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/DateTime.html#method-i-strftime

require 'date'
# There are two time classes:
# time in the core library
# time in the standard library
# require 'time' loads the standard library version which adds useful methods
# such as parse and strptime
require 'time'

site     = 'google.com:443'
cmd      = "echo | openssl s_client -connect #{site} 2>/dev/null | openssl x509 -noout -dates"
std_out  = `#{cmd}`
cert_exp = std_out.match(/notAfter=(?<timestamp>[\w :]+)/)

puts "Raw timestamp: #{cert_exp['timestamp']}"

# All three of these methods parse the time correctly
a = DateTime.strptime(cert_exp['timestamp'], '%b  %d %H:%M:%S %Y %Z')
b = Date.parse(cert_exp['timestamp'])
c = DateTime.parse(cert_exp['timestamp'])
# For whatever reason, the parse method in time cannot correctly parse
d = Time.parse(cert_exp['timestamp'])
# But strptime works
e = Time.strptime(cert_exp['timestamp'], '%b  %d %H:%M:%S %Y %Z')

puts "DateTime.strptime Expiration: #{a.strftime('%Y-%m-%d %H:%M:%S %Z')}"
puts "Date.parse Expiration date: #{b.strftime('%Y-%m-%d')}"
puts "DateTime.parse Expiration time: #{c.strftime('%H:%M:%S')}"
puts "The array will show how time.parse parses incorrectly"
puts "Time.parse Expiration time: #{d.to_a}"
puts "Note how Time.strptime sets the time zone to CDT and does not leave it " \
     "it at the default timezone of GMT"
puts "Time.strptime Expiration: #{e.strftime('%Y-%m-%d %H:%M:%S %Z')}"
puts "Time.utc.strptime Expiration: #{e.utc.strftime('%Y-%m-%d %H:%M:%S %Z')}"
puts "DateTime.strptime.to_time Expiration: #{a.to_time.strftime('%Y-%m-%d %H:%M:%S %Z')}"
puts "DateTime.strptime.to_time.to_i Expiration: #{a.to_time.to_i}"
