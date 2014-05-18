=begin
  This script was used to pull common names from files in a ssl
  directory and then create new directories based on those
  common names.  We then move all files that match that common
  name over to the common name directory.
=end

require 'fileutils'

# Traverse through the certs, private, and csr directories
Dir.glob('*').each do |d|
  puts "==============#{d}==================="
  Dir.glob("#{d}/*").each do |f| 
    # Create a match object that stores the common name in :cn
    match = /#{d}\/(?<cn>.*)\./.match(f)
    puts "Creating dir #{match[:cn]}"
    FileUtils.mkdir(match[:cn]) unless Dir.exists?(match[:cn])
    # Move <cn>* file names over to the common name directory
    FileUtils.mv(Dir.glob("#{d}/#{match[:cn]}*"), "#{match[:cn]}/")
  end
end

# Prints the common name that was found for each file in each dir
Dir.glob("certs/*").each {|f| puts /certs\/(?<cn>.*)\./.match(f)[:cn]}
Dir.glob("private/*").each {|f| puts /private\/(?<cn>.*)\./.match(f)[:cn]}
Dir.glob("csr/*").each {|f| puts /csr\/(?<cn>.*)\./.match(f)[:cn]}
