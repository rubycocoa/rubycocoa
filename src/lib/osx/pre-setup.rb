# generate foundation.rb and appkit.rb
tooldir = "#{srcdir_root}/tool"
[
  [ "/System/Library/Frameworks/Foundation.framework/Headers/*.h",
    "foundation.rb" ],
  [ "/System/Library/Frameworks/AppKit.framework/Headers/*.h",
    "appkit.rb" ]
].each do |path, fname|
  fname = File.join(curr_srcdir, fname)
  ruby "#{tooldir}/gen_imports.rb #{path} > #{fname}"
end

