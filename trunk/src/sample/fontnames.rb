require 'osx/cocoa'

fmgr = OSX::NSFontManager.sharedFontManager

puts "## all fonts ##"
fonts = fmgr.availableFonts.map{|i| i.to_s }
fonts.each {|i| puts i }

puts "## fixed pitch fonts ##"
fixedfonts =
  fmgr.availableFontNamesWithTraits(OSX::NSFixedPitchFontMask)
fixedfonts.each {|i| puts i.to_s }

