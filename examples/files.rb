#!/usr/bin/env ruby -w

def file_open_no_block
  puts "BEGIN: __method__"
  puts "Output contents of file"
  puts '$0 = file name of the ruby script'
  file_to_open = $0
  f = File.open(file_to_open)
  puts f.read
  puts "Rewind the current file"
  f.seek(0, IO::SEEK_SET)
  puts f.read
  f.close
  puts "END: __method__"
end

def file_open_with_block
  puts "BEGIN: __method__"
  puts "Block form of File.open which closes the handle at the end of the block"
  file_to_open = $0
  File.open(file_to_open) do |f|
    puts f.read
  end
  puts "END: __method__"
end

def manage_cwd
  puts "cwd: #{Dir.pwd}"
  Dir.chdir('/opt')
  puts "new cwd: #{Dir.pwd}" 
end

#file_open_no_block
#file_open_with_block
#file_open_with_block
#manage_cwd
