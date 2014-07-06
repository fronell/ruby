# References:
# http://rakeroutes.com/blog/parsing-dates-and-times-from-strings/
# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/DateTime.html#method-i-strftime

require 'date'

site     = 'google.com:443'
cmd      = "echo | openssl s_client -connect #{site} 2>/dev/null | openssl x509 -noout -dates"
std_out  = `#{cmd}`
cert_exp = std_out.match(/notAfter=(?<timestamp>[\w :]+)/)

puts "Raw timestamp: #{cert_exp['timestamp']}"

# All three of these methods parse the time correctly
a = DateTime.strptime(cert_exp['timestamp'], '%b  %d %H:%M:%S %Y %Z')
b = Date.parse(cert_exp['timestamp'])
c = DateTime.parse(cert_exp['timestamp'])

puts "Expiration: #{a.strftime('%Y-%m-%d %H:%M:%S')}"
puts "Expiration date: #{b.strftime('%Y-%m-%d')}"
puts "Expiration time: #{c.strftime('%H:%M:%S')}"
