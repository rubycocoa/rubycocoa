######################
#### BEGIN CONFIG ####
######################

APP_NAME = "SimpleApp"
BUNDLE_ID = "appdomain." + APP_NAME

RUBY_SOURCES = [
  # :AppCtrl,
  # :AppView
]
######################
##### END CONFIG #####
######################


TMPLDIR = 'tmpl'

def gen_file (srcpath, dstpath, sub_pats = [])
  File.open(srcpath) do |src|
    File.open(dstpath, "w") do |dst|
      src.each do |line|
	sub_pats.each {|a0,a1| line.sub! (a0, a1) }
	dst.write (line)
      end
    end
  end
end

def gen_plist
  dst = "Info.plist"
  src = "#{TMPLDIR}/#{dst}.tmpl"
  arg = [
    [ /%%%%APP_NAME%%%%/,  APP_NAME ],
    [ /%%%%BUNDLE_ID%%%%/, BUNDLE_ID ]
  ]
  gen_file (src, dst, arg)
end

def gen_makefile
  rbsrc_names = RUBY_SOURCES.map{|i| "#{i.to_s}.rb" }.join(' ')
  dst = "Makefile"
  src = "#{TMPLDIR}/#{dst}.tmpl"
  arg = [
    [ /%%%%APP_NAME%%%%/, APP_NAME ],
    [ /%%%%RUBY_SOURCES%%%%/, rbsrc_names ]
  ]
  gen_file (src, dst, arg)
end

if __FILE__ == $0 then
  gen_plist
  gen_makefile
end
