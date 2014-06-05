require 'rbconfig'

# Xcode generates unwanted symlink "Headers" under Headers/
unwanted_symlink = 'build/Default/RubyCocoa.framework/Headers/Headers'
File.delete(unwanted_symlink) if File.symlink?(unwanted_symlink)
