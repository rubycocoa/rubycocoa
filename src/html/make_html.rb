#!/usr/bin/env ruby

SRCDIR = "../doc"
DSTDIR = "."

def command(cmd)
  $stderr.puts "execute '#{cmd}' ..."
  raise (RuntimeError, cmd) unless system(cmd)
end

def rd2(src, dst, title, lang, css = nil, charset = nil)
  unless charset then
    charset = case lang
	      when 'en' then "us-ascii"
	      when 'ja' then "euc-jp"
	      end
  end
  css = "rdtext.css" unless css
  opt_lang = "--html-lang=#{lang}" if lang
  opt_charset = "--html-charset=#{charset}" if charset
  opt_css = "--with-css=#{css}" if css
  opt_title = "--html-title='#{title}'" if title
  cmdstr = "rd2 -r rd/rd2html-lib #{opt_title} #{opt_css} #{opt_charset} #{opt_lang}"
  command "#{cmdstr} #{src} > #{dst}"
end

docs = Dir["#{SRCDIR}/*.{ja,en}"]

docs.each do |path|
  dirname = File.dirname(path)
  filename = File.basename(path)
  docname = filename.split('.')[0..-2].join
  lang = filename.split('.')[-1]
  title = "RubyCocoa - #{docname}"
  dstpath = "#{DSTDIR}/#{docname}.#{lang}.html"
  rd2 (path, dstpath, title, lang)
end
