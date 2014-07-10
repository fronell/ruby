def manage_cwd
  puts "cwd: #{Dir.pwd}"
  Dir.chdir('/opt')
  puts "new cwd: #{Dir.pwd}" 
end

#manage_cwd
