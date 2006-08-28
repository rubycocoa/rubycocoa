# generate bridge support metadata files for Foundation/AppKit
command('mkdir -p framework/bridge-support')
['Foundation', 'AppKit'].each do |fname|
  command("DYLD_FRAMEWORK_PATH=./framework/build/Default ruby -I./ext/rubycocoa -I./lib framework/tool/generate_bridge_support.rb #{fname} > ./framework/bridge-support/#{fname}.xml")
end
