require 'rbconfig'

# Xcode generates unwanted symlink "Headers" under Headers/
unwanted_symlink = "#{framework_obj_path}/RubyCocoa.framework/Headers/Headers"
File.delete(unwanted_symlink) if File.symlink?(unwanted_symlink)
