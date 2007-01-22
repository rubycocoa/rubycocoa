require 'fileutils'

unless File.exist?('bridge-doc')
  Dir.chdir('tool') do
    ruby("gen_bridge_doc.rb build ../bridge-doc")
  end
end
