prj_tmpl_file = 'RubyCocoa.pbproj/project_tmpl.pbxproj'
prj_dst_file = 'RubyCocoa.pbproj/project.pbxproj'

tmpl = File.open(prj_tmpl_file){|f| f.read }

[
  [ :frameworks,      @config['frameworks'] ],
  [ :ruby_header_dir, @config['ruby-header-dir'] ],
  [ :libruby_path,    @config['libruby-path'] ],
  [ :libruby_path_dirname, File.dirname(@config['libruby-path']) ],
  [ :libruby_path_basename, File.basename(@config['libruby-path']) ]
].each do |sym, str|
  pat = "%%%#{sym}%%%"
  tmpl.gsub! (pat, str)
end

File.open(prj_dst_file,"w"){|f| f.write(tmpl) }
