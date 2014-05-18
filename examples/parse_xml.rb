#!/usr/bin/env ruby
#Test parsing of xml document using XmlSimple and REXML
################################### FIXME ####################################


################################### TODO #####################################


################################# CHANGE LOG #################################
#0.0.1: 2012-06-02
#  -Initial VERSION


################################# MODULES ####################################
require 'rubygems'
require 'xmlsimple'
require 'rexml/document'
include REXML


################################# GLOBALS ####################################
BUILD_VERSION = '0.0.1'
BUILD_DATE = '2012-06-04'


############################ PROGRAM FUNCTIONS ################################
def time_stamp
  time = Time.new
  #Ruby 1.8x Time class does not support outputting microseconds
  time.strftime('%Y-%m-%d %H:%M:%S')
end

def info_msg(msg)
  $stdout.puts "#{ time_stamp }| #{ msg }"
end
  
def err_msg(msg)
  $stderr.puts "#{ time_stamp }| #{ msg }"
end

def run_cmd(cmd)
  info_msg("cmd=#{ cmd }")
  output = `#{ cmd }`
  #output = `#{ cmd } 2>&1`
  exit_code = $?.exitstatus
  return exit_code, output
end


################################### MAIN #####################################
info_msg("VERSION #{ BUILD_VERSION } Build Date: #{ BUILD_DATE } starting...")
info_msg("[=============== BEGIN ===============]")
#SimpleXml
#SimpleXml will convert the xml document into a hash data structure
#While this method does make it simple to access data within XML, I do not think
#of the abstraction of the XML data into a hash data structure is the best way
#to deal with it from a maintainability standpoint
config = XmlSimple.xml_in('c:\file.xml',
                          { 'KeyAttr' => ['name', 'state'] })

#REXML
#References:
#http://www.germane-software.com/software/rexml/docs/tutorial.html (Best)
#http://www.tutorialspoint.com/ruby/ruby_xml_xslt.htm
#https://www.x.com/devzone/articles/ruby-cookbook-chapter-11-xml-and-html-oreilly-media
xmlfile = File.new('c:\file.xml')
xmldoc = Document.new(xmlfile)
xmldoc.elements.each('element') do |e|
end    
info_msg('[================ END ================]')
