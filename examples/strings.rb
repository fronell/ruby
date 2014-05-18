#Reference: http://stackoverflow.com/questions/1552598/building-multi-line-strings-programatically-in-ruby

puts 'single quotes is similar to python raw strings so c:\downloads does not get escaped\n'
puts "\n"

unsigned_files = ['file1.txt', 'file2.txt']

msg =  "More than one unsigned billing file found to upload!\n"
msg << "Aborting because there should only be one file to upload a month\n"
msg << "Found the following files to upload:\n"
msg << unsigned_files.inspect
puts "#{ msg }\n\n"
    
msg = ["More than one unsigned billing file found to upload!",
       "Aborting because there should only be one file to upload a month",
       "Found the following files to upload:",
       unsigned_files.inspect].join("\n")
puts "#{ msg }\n\n"
    
#The gsub is used to eliminate 6 white spaces at the beginning of each line
msg = <<END.gsub(/^ {2}/, '')
  More than one unsigned billing file found to upload!
  Aborting because there should only be one file to upload a month
  Found the following files to upload:
  #{ unsigned_files.inspect }
END
puts "#{ msg }\n"

#The - makes sure any white space before the end marker is ignored, use for
#indenting
msg = <<-END.gsub(/^ {2}/, '')
  More than one unsigned billing file found to upload!
  Aborting because there should only be one file to upload a month
  Found the following files to upload:
  #{ unsigned_files.inspect }
  END
puts "#{ msg }\n"

msg = "This is yet another way that strings can be combined\n" +
      "It might seem a little cleaner, but I'm not sure\n" +
      "The jury is still out on this one\n" +
      "I got it from reading the code in FasterCSV"
puts "#{ msg }\n"
