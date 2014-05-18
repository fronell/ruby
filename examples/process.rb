#def runCmd(cmd)
#Ruby requires them gem Open4#popen4 to handle stdout, stderr and return code
#Use backticks `` to make system calls since it returns stdout and the return code
#Use `command 2>&1` to redirect stderr to stdout to at least get it
#http://whynotwiki.com/Ruby_/_Process_management#How_do_I_execute_an_external_program.3F
#http://tech.natemurray.com/2007/03/ruby-shell-commands.html
#end

#Reference: https://gist.github.com/4069

# Ways to execute a shell script in Ruby
# Example Script - Joseph Pecoraro

cmd = "echo 'hi'" # Sample string that can be used

# 1. Kernel#` - commonly called backticks - `cmd`
# This is like many other languages, including bash, PHP, and Perl
# Returns the result of the shell command
# Docs: http://ruby-doc.org/core/classes/Kernel.html#M001111

value = `echo 'hi'` # or uglier but valid => Kernel.`("echo 'hi'")
value = `#{cmd}` # or uglier but valid => Kernel.`("#{cmd}")


# 2. Built-in syntax, %x( cmd )
# Following the ``x'' character is a delimiter, which can be any character.
# If the delimiter is one of the characters ``('', ``['', ``{'', or ``<'',
# the literal consists of the characters up to the matching closing delimiter,
# taking account of nested delimiter pairs. For all other delimiters, the
# literal comprises the characters up to the next occurrence of the
# delimiter character. String interpolation #{ ... } is allowed.
# Returns the result of the shell command, just like the backticks
# Docs: http://www.ruby-doc.org/docs/ProgrammingRuby/html/language.html

value = %x( echo 'hi' )
value = %x[ #{cmd} ]


# 3. Kernel#system
# Executes the given command in a subshell
# Return: true if the command was found and ran successfully, false otherwise
# Docs: http://ruby-doc.org/core/classes/Kernel.html#M002992

wasGood = system( "echo 'hi'" )
wasGood = system( cmd )


# 4. Kernel#exec
# Replaces the current process by running the given external command.
# Return: none, the current process is replaced and never continues
# Docs: http://ruby-doc.org/core/classes/Kernel.html#M002992

exec( "echo 'hi'" )
exec( cmd ) # Note: this will never be reached beacuse of the line above


# Extra Advice
# $? which is the same as $CHILD_STATUS (if you require 'english')
# Accesses the status of the last system executed command if
# you use the backticks, system() or %x{}.
# You can then access the ``exitstatus'' and ``pid'' properties

$?.exitstatus

# More Reading
# http://blog.jayfields.com/2006/06/ruby-kernel-system-exec-and-x.html
# http://tech.natemurray.com/2007/03/ruby-shell-commands.html

# http://popen4.rubyforge.org/
def run_cmd_with_scrub(cmd, string_to_scrub)
  info_msg("cmd=#{ cmd }")
  cmd_stdout = ''
  cmd_stderr = ''
  cmd_pid = ''
  
  #POpen4 was chosen for system commands because it supports returning
  #  stdout, stderr, exit status, and stdin input for both Unix & Windows
  #POpen4 does not work if its passed 2>&1, something is not getting escaped
  #  properly but I couldn't figure it out
  status =
    POpen4::popen4(cmd) do |stdout, stderr, stdin, pid|
      cmd_pid = pid 
      cmd_stdout = stdout.read.strip
      cmd_stderr = stderr.read.strip
    end
  cmd_exit_status = status.exitstatus
  return cmd_exit_status, cmd_stdout, cmd_stderr, cmd_pid
end
