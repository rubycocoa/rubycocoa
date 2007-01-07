require 'rubygems'
require 'redcloth'
require 'syntax/convertors/html'

HEADER = <<EOS
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en-US">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Language" content="en-US">
  <link rel="stylesheet" type="text/css" href="style.css">
  <title>RubyCocoa 1.0 Sneak Preview</title>
</head>
<body>
EOS

Dir.glob("*.txt").each do |txt|
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
      io.write(HEADER)
      io.write(h)
    end
end
# scp * lrz@shell.sf.net:/home/groups/r/ru/rubycocoa/htdocs/doc/unstable
