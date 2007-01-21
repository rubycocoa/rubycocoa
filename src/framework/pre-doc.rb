require 'fileutils'

unless File.exist?('bridge-doc')
  Dir.chdir('tool') do
    unless system("#{@config['ruby-prog']} gen_bridge_doc.rb build ../bridge-doc")
      $stderr.puts "Documentation generation failed"
      exit 1
    end
  end
end
