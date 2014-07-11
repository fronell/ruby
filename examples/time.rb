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
  -You can do microseconds with time
  -DateTime has no concept of leap seconds
  -DateTime has no concept of daylight savings
  -In general, the impression I got is most people use Time

One disadvantage I found with Time is the parse method is not as accurate as
DateTime.parse.  With the following timestamp:

Sep  2 00:00:00 2014 GMT

DateTime.parse will parse it correctly but Time.parse creates a Time object with the following values:

[0, 0, 0, 2, 9, 2014, 2, 245, true, "CDT"]

The time is completely incorrect from Time.parse.
  
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

=begin
These directives can be used with strptime and strftime
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

def time_class
  puts "BEGIN: #{__method__}"
  # There are two time classes:
  # time in the core library
  # time in the standard library
  # require 'time' loads the standard library version which adds useful methods
  # such as parse and strptime
  require 'time'

  # Time.new is synonymous with Time.now
  now = Time.now

  puts "Current time=#{now.strftime('%Y-%m-%d %H:%M:%S %Z')}"
  puts "year=#{now.year}"
  puts "month=#{now.month}"
  puts "day=#{now.day}"
  puts "wday=#{now.wday}"
  puts "day of year=#{now.yday}"
  puts "hour=#{now.hour}"
  puts "min=#{now.min}"
  puts "second=#{now.sec}"
  puts "microsecond=#{now.usec}"
  puts "timezone=#{now.zone}"
  puts "utc offset in seconds=#{now.utc_offset}"

  # Create a time object for 2013-04-07 15:07:35.600
  # Arguments that can be passed:
  # (year, month, day, hour, min, sec, usec_with_frac)
  # Notice how month can be the short name or number
  puts "Time.utc=#{Time.utc(2013,"apr",07,15,07,35,600)}"
  puts "Time.local=#{Time.local(2013,04,07,15,07,35,600)}"
  # Time.new does not support microseconds
  # (year, month, day, hour, min, sec, UTC offset)
  puts "Time.new=#{Time.new(2013,04,07,15,07,35,'-08:00')}"
  puts "Time.at(epoch time)=#{Time.at(1365365255)}"
  puts "Time.strptime=#{Time.strptime('2013-04-07 15:07:35.600', '%Y-%m-%d %H:%M:%S.%L')}"
  puts "Note how strptime will output to local time by default:"
  puts "Time.strptime for 'Apr  7 15:07:35 2013 GMT'=" \
       "#{Time.strptime('Apr  7 15:07:35 2013 GMT', '%b  %d %H:%M:%S %Y %Z')}"

  puts "Current Epoch time=#{now.to_i}"
  puts "Current Epoch time with microseconds=#{now.to_f}"

  puts "10 days from now=#{now + (60 * 60 * 24 * 10)}"
  puts "10 days before now=#{now - (60 * 60 * 24 * 10)}"

  puts "END: #{__method__}"
end

def date_class
  puts "BEGIN: #{__method__}"
  #The Date class can be useful when you're only concernced with comparing dates 
  require 'date'
  now = Date.today
  puts "now=#{now}"
  puts "90 days ago=#{(now - 90)}"
  puts "Date.new=#{Date.new(1997, 12, 31)}"
  puts "now.to_time=#{now.to_time}"
  puts "now.to_datetime=#{now.to_datetime}"
  puts "END: #{__method__}"
end

def datetime_class
  puts "BEGIN: #{__method__}"
  require 'date'
  timestamp = "Sep  2 07:32:45 2014 GMT"
  # DateTime.parse can parse this timestamp but Time can't
  parsed = DateTime.parse(timestamp)
  puts "Parsed [#{timestamp}]=#{parsed}"
  puts "parsed.to_time=#{parsed.to_time}"
  puts "parsed.to_date=#{parsed.to_date}"
  puts "END: #{__method__}"
end

time_class
date_class
datetime_class
