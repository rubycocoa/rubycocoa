# parse arg

def usage
  $stderr.puts "usage: ruby install_html.rb FILE... TARGET_DIR"
  exit 1
end

# parse args
SRCS = ARGV[0..-2]
TARGET = ARGV[-1]

# check arg
usage unless FileTest.directory?( TARGET )
SRCS.each {|src| usage unless FileTest.file?( src ) }

# diff ignore pattern
PAT_1 = '\$Date:.*\$'
PAT_2 = '\$Revision:.*\$'

# process
SRCS.each do |src|
  dstpath = File.join( TARGET, File.basename( src ) )
  cmdstr = "diff --brief -u -I '#{PAT_1}' -I '#{PAT_2}' #{src} #{dstpath}"
  unless system( cmdstr )  then
    cmdstr = "cp -f -p #{src} #{dstpath}"
    # $stderr.puts( cmdstr ) if system( cmdstr )
    $stderr.puts( cmdstr )
  end
end
