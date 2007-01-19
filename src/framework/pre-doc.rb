require 'fileutils'

unless File.exist?('bridge-doc')
  Dir.chdir('tool') do
    unless system("#{@config['ruby-prog']} gen_bridge_doc.rb build")
      $stderr.puts "Documentation generation failed"
      exit 1
    end
    FileUtils.mv('doc', '../bridge-doc')
  end
end
