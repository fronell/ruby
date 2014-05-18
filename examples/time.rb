=begin
 References
 http://stackoverflow.com/questions/1261329/whats-the-difference-between-datetime-and-time-in-ruby
 Ruby has three different time modules:
 Time
 Date
 DateTime
 The following is a good explanation of the different modules:
   Time is a wrapper around Unix-Epoch. 
   Date (and DateTime) use rational and a "day zero" for storage. So Time 
   is faster but the upper and lower bounds are tied to epoch time (which 
   for 32bit epoch times is something around 1970-2040 while Date 
   (and DateTime) have an almost infinite range  but are *terribly* slow.
   1.8.x notes:
     -Time is significantly faster than Date or DateTime
     -Time is 32bit so its limited between 1970-2040
     -Time.parse and 
   1.9.x notes:
     -Time is not limited by the 32bit int and can cover a much larger range
     -DateTime is significantly faster and only slightly slower than Time
     
I've decided to go with the Time module for the following reasons:
  -Its speed in Ruby 1.8
  -Its easier to calculate different times using seconds
  -It works with epoc time
  
If we are reading in a timestamp stamp though and we do not have to doing any
calculations from it, then using DateTime.strptime(str, format) is preferable
beause you can ensure that the time string you're reading will get parsed
correctly

Researching different ways of doing time calculations yielded code such as:
  30.seconds.ago
  2.days.ago
  2.days.since
  2.days.from_now
  2.hours
  2.days
The above all require the ActiveSupport gem which is part of Ruby on Rails but
got separated out as a gem for Ruby.  It should be noted that Ruby on Rails has 
sort of polluted the information of what you can do with vanilla Ruby since
so many people are using it.
=end


#Reference: http://www.tutorialspoint.com/ruby/ruby_date_time.htm
time1 = Time.new

puts "Current Time : " + time1.inspect

# Time.now is a synonym:
time2 = Time.now
puts "Current Time : " + time2.inspect

######

time = Time.new

# Components of a Time
puts "Current Time : " + time.inspect
puts time.year    # => Year of the date 
puts time.month   # => Month of the date (1 to 12)
puts time.day     # => Day of the date (1 to 31 )
puts time.wday    # => 0: Day of week: 0 is Sunday
puts time.yday    # => 365: Day of year
puts time.hour    # => 23: 24-hour clock
puts time.min     # => 59
puts time.sec     # => 59
puts time.usec    # => 999999: microseconds
puts time.zone    # => "UTC": timezone name

######

# July 8, 2008
puts Time.local(2008, 7, 8)  
# July 8, 2008, 09:10am, local time
puts Time.local(2008, 7, 8, 9, 10)   
# July 8, 2008, 09:10 UTC
puts Time.utc(2008, 7, 8, 9, 10)  
# July 8, 2008, 09:10:11 GMT (same as UTC)
puts Time.gm(2008, 7, 8, 9, 10, 11)

######

#Following is the example to get all components in an array in the following format:
#[sec,min,hour,day,month,year,wday,yday,isdst,zone]

time = Time.new

values = time.to_a
p values

######

time = Time.new

values = time.to_a
#This array could be passed to Time.utc or Time.local functions to get different format of dates as follows:
puts Time.utc(*values)

######

#Convert from epoc time
converted_time = Time.at(1299923423).strftime('%Y-%m-%d %H:%M:%S')
puts "converted epoc time: #{ converted_time }"

# Returns number of seconds since epoch
time = Time.now.to_i  

# Convert number of seconds into Time object.
Time.at(time)

# Returns second since epoch which includes microseconds
time = Time.now.to_f

######

time = Time.new

# Here is the interpretation
time.zone       # => "UTC": return the timezone
time.utc_offset # => 0: UTC is 0 seconds offset from UTC
time.zone       # => "PST" (or whatever your timezone is)
time.isdst      # => false: If UTC does not have DST.
time.utc?       # => true: if t is in UTC time zone
time.localtime  # Convert to local timezone.
time.gmtime     # Convert back to UTC.
time.getlocal   # Return a new Time object in local zone
time.getutc     # Return a new Time object in UTC

#######

time = Time.new

puts time.to_s
puts time.ctime
puts time.localtime
puts time.strftime("%Y-%m-%d %H:%M:%S")

#####

#Time calculations
now = Time.now     # Current time

past = now - 10    # 10 seconds ago. Time - number => Time
future = now + 10  # 10 seconds from now Time + number => Time
future - now       # => 10  Time - Time => number of seconds

######

=begin
Time Formatting Directives:

These directives in the following table are used with the method Time.strftime.
Directive Description
%a  The abbreviated weekday name (Sun).
%A  The full weekday name (Sunday).
%b  The abbreviated month name (Jan).
%B  The full month name (January).
%c  The preferred local date and time representation.
%d  Day of the month (01 to 31).
%H  Hour of the day, 24-hour clock (00 to 23).
%I  Hour of the day, 12-hour clock (01 to 12).
%j  Day of the year (001 to 366).
%m  Month of the year (01 to 12).
%M  Minute of the hour (00 to 59).
%p  Meridian indicator (AM or PM).
%S  Second of the minute (00 to 60).
%U  Week number of the current year, starting with the first Sunday as the first day of the first week (00 to 53).
%W  Week number of the current year, starting with the first Monday as the first day of the first week (00 to 53).
%w  Day of the week (Sunday is 0, 0 to 6).
%x  Preferred representation for the date alone, no time.
%X  Preferred representation for the time alone, no date.
%y  Year without a century (00 to 99).
%Y  Year with century.
%Z  Time zone name.
%%  Literal % character.
=end

######

#The Date class can be useful when you're only concernced with comparing dates 
require 'date'
now = Date.today
ninety_days_ago = (now - 90)
puts ninety_days_ago
d = Date.new(1997, 12, 31)
puts d
puts d + 10

######

require 'parsedate'

#Parsing time from a string
#The order is of the form [year, month, day of month, hour, minute, second, timezone, day of week].
date = "Friday 2012-08-10 12:23:57 CST"
parsed_date = ParseDate.parsedate(date)
puts parsed_date.to_s
#If we have year represented as two digits only
date = "Friday 12-08-10 12:23:57 CST"
parsed_date = ParseDate.parsedate(date, true)
puts parsed_date.to_s
#ParseDate will parse everything up to the second correctly but it does not parse
#microseconds
puts ParseDate.parsedate("2012-08-10 12:25:35,086").to_s

#How to convert from a parsed date to a time object
#Uisng the * splat operator to unroll the array as a list of arguments
p = parsed_date
puts Time.local(*p)
#And the ugly way where we pass each argument individually
puts Time.local(p[0], p[1], p[2], p[3], p[4], p[5])

#How to parse from a string to Date and DateTime
puts Date.parse('2/9/2007').to_s
puts Date.parse('Friday, November 21, 2008').to_s

#Parsing may not always work, in the following, the parse method gets the month wrong
puts "Wrong: #{ DateTime.parse('02-09-2007 12:30:44 AM') }"
#Instead, we can specify the time format of the string to get the correct month
twelve_hour_clock_time = '%m-%d-%Y %I:%M:%S %p'
p = DateTime.strptime('02-09-2007 12:30:44 AM', twelve_hour_clock_time)
puts "Right: #{ p }"
puts Date.strptime('02-09-2007', '%m-%d-%Y')

#Formatting DateTime
puts p.strftime("%Y-%m-%d %H:%M:%S")
