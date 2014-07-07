=begin
References
  http://stackoverflow.com/questions/1261329/whats-the-difference-between-datetime-and-time-in-ruby
  http://stackoverflow.com/questions/5941613/are-the-date-time-and-datetime-classes-necessary
Ruby has three different time modules:
  Time
  Date
  DateTime
     
I've decided to go with the Time module for the following reasons:
  -Since time is just seconds, it makes arithmetic and comparing easy
  -DateTime has no concept of leap seconds
  -DateTime has no concept of daylight savings
  -In general, the impression I got is most people use Time
  
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

def time_class
  # There are two time classes:
  # time in the core library
  # time in the standard library
  # require 'time' loads the standard library version which adds useful methods
  # such as parse and strptime
  require 'time'

  # Time.new is synonymous with Time.now
  now = Time.now

  puts "Current time is #{now.strftime('%Y-%m-%d %H:%M:%S %Z')}"
  puts now.year    # => Year of the date 
  puts now.month   # => Month of the date (1 to 12)
  puts now.day     # => Day of the date (1 to 31 )
  puts now.wday    # => 0: Day of week: 0 is Sunday
  puts now.yday    # => 365: Day of year
  puts now.hour    # => 23: 24-hour clock
  puts now.min     # => 59
  puts now.sec     # => 59
  puts now.usec    # => 999999: microseconds
  puts now.zone    # => "UTC": nowzone name

  #Following is the example to get all components in an array in the following format:
  #[sec,min,hour,day,month,year,wday,yday,isdst,zone]

  # Create a time object for 2012-04-02 17:05:32
  # July 8, 2008
  puts Time.local(2008, 7, 8)  
  # July 8, 2008, 09:10am, local time
  puts Time.local(2008, 7, 8, 9, 10)   
  # July 8, 2008, 09:10 UTC
  puts Time.utc(2008, 7, 8, 9, 10)  
  # July 8, 2008, 09:10:11 GMT (same as UTC)
  puts Time.gm(2008, 7, 8, 9, 10, 11)
  values = time.to_a
  p values
  
  ######
  
  time = Time.new
  
  values = time.to_a
  #This array could be passed to Time.utc or Time.local functions to get different format of dates as follows:
  puts Time.utc(*values)
#Convert from epoc time
converted_time = Time.at(1299923423).strftime('%Y-%m-%d %H:%M:%S')
puts "converted epoc time: #{ converted_time }"

# Returns number of seconds since epoch
time = Time.now.to_i  

# Convert number of seconds into Time object.
Time.at(time)

# Returns second since epoch which includes microseconds
time = Time.now.to_f

#Time calculations
now = Time.now     # Current time

past = now - 10    # 10 seconds ago. Time - number => Time
future = now + 10  # 10 seconds from now Time + number => Time
future - now       # => 10  Time - Time => number of seconds

end

def datetime_class

end

def time_parsing
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
  
  #Parsing may not always work, in the following, the parse method gets the month wrong
  puts "Wrong: #{ DateTime.parse('02-09-2007 12:30:44 AM') }"
  #Instead, we can specify the time format of the string to get the correct month
  twelve_hour_clock_time = '%m-%d-%Y %I:%M:%S %p'
  p = DateTime.strptime('02-09-2007 12:30:44 AM', twelve_hour_clock_time)
  puts "Right: #{ p }"
  puts Date.strptime('02-09-2007', '%m-%d-%Y')
end

######

def date_method
  #The Date class can be useful when you're only concernced with comparing dates 
  require 'date'
  now = Date.today
  ninety_days_ago = (now - 90)
  puts ninety_days_ago
  d = Date.new(1997, 12, 31)
  puts d
  puts d + 10
end

