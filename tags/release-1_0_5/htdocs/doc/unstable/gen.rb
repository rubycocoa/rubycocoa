require 'rubygems'
require 'redcloth'
require 'syntax/convertors/html'

def header(lang)
  <<"EOS"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="#{lang}">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Language" content="#{lang}">
  <link rel="stylesheet" type="text/css" href="style.css">
  <title>RubyCocoa 1.0 Sneak Preview</title>
</head>
<body>
EOS
end

Dir.glob("*.txt").each do |txt|
    ma = /-(.*)\.txt$/.match(txt)
    lang = ma ? ma[1] : 'en-US'
    html = txt.sub(/txt$/, 'html')
    r = RedCloth.new(IO.read(txt))
    File.open(html, 'w') do |io|
      puts "Generating #{html}..."
=begin
      h = r.to_html.gsub(/<code>([^\<]*)<\/code>/m) do |match|
        code = $1
        Syntax::Convertors::HTML.for_syntax('ruby').convert(code)
      end
=end
      h = r.to_html
      io.write(header(lang))
      io.write(h)
    end
end
# scp * lrz@shell.sf.net:/home/groups/r/ru/rubycocoa/htdocs/doc/unstable
