#!/usr/bin/env ruby
require 'docutils'

if ARGV.size != 2 then
  $stderr.puts "usage: ruby make_html.rb SRCFILE DSTDIR"
  exit 1
end

SRCFILE = ARGV.shift
DSTDIR = ARGV.shift

def rd_to_html(src, dst, lang, charset = nil)
  unless charset then
    charset = case lang
	      when 'en' then "us-ascii"
	      when 'ja' then "euc-jp"
	      end
  end
  $stderr.print "#{src}..." ; $stderr.flush
  tmpl = PageTemplate.new( 'page-template.html' )

  # setup embeding parts. 
  [
    ["site-menubar.#{lang}.xml", 'site-menubar' ],
    ["sidebar-news.#{lang}.xml", 'sidebar-news' ],
    ["sidebar-contents.#{lang}.xml", 'sidebar-contents' ],
    ["sidebar-links.#{lang}.xml", 'sidebar-links' ],

  ].each do |fname, idval|
    xmlsrc = File.open(fname){|f|f.read}
    xmldoc = REXML::Document.new( xmlsrc )
    tmpl.replace_elements( 'id', idval, xmldoc.root )
  end

  rdoc = RDDocument.new(src)
  tmpl.set_title( rdoc.title )
  tmpl.set_contents( rdoc.body )
  tmpl.set_lang( lang )
  tmpl.write_to_file( dst )
  $stderr.puts "done."
end

docs = [ SRCFILE ]

docs.each do |path|
  dirname = File.dirname(path)
  filename = File.basename(path)
  docname = filename.split('.')[0..-2].join
  lang = filename.split('.')[-1]
  dstpath = "#{DSTDIR}/#{docname.downcase}.#{lang}.html"
  rd_to_html(path, dstpath, lang)
end
