require 'uconv'
require 'kconv'
require 'rexml/document'
require 'rd/rd2html-lib'
require 'rd/rdfmt'

module REXML

  class Element

    def find_attribute( key, val )
      return self if attributes[key] == val
      self.each_element do |elm|
	ret = elm.find_attribute( key, val )
	return ret if ret
      end
      return nil
    end

  end
end

class PageTemplate

  def initialize (tmpl_name)
    src = File.open(tmpl_name){|f|f.read}
    @doc = REXML::Document.new(src)
  end

  def write_to_file(fname)
    File.open(fname, 'w') {|f| f.write(@doc.to_s) }
    self
  end

  def set_title (str)
    if not str.nil? then
      str = 'RubyCocoa - ' << str
      @doc.root.elements["head/title"].text = Uconv::euctou8(str.toeuc)
      nil
    end
  end

  def set_contents( elm )
    replace_elements( 'id', 'body-contents', elm )
  end

  def replace_elements (src_key, src_val, new_elm)
    target = @doc.find_attribute( src_key, src_val )
    if target then
      target.to_a.each {|i| target.delete(i) }
      new_elm.each do |i|
	if i.respond_to? :deep_clone then
	  target.add(i.deep_clone)
	else
	  target.add(i.clone)
	end
      end
    end
    nil
  end

  def set_lang( lang )
    enc = nil
    if lang == 'ja'
      enc = 'euc-jp'
    else
      lang = 'en'
      enc = 'us-ascii'
    end
    @doc.xml_decl.encoding = enc
    @doc.root.attributes['lang'] = lang
    @doc.root.attributes['xml:lang'] = lang
    @doc.elements['html/head/meta[@http-equiv="Content-type"]'].
      attributes['content'] = "text/html; charset=#{enc}"
    @doc.elements['html/head/meta[@name="Content-Language"]'].attributes['content'] = lang
  end

  def inspect
    return super[0..80]
  end

  def to_s
    @doc.to_s
  end

end



class RDDocument

  attr_reader :src_name, :title, :body

  def initialize(fname)
    @src_name = fname
    charset = "us-ascii"
    lang = "en"
    if /\.ja\z/ =~ fname then
      charset = "euc-jp"
      lang = "ja"
    end
    rd2(fname, "/tmp/rubycocoahoge" , lang)
    xml_src = `cat /tmp/rubycocoahoge`
    command 'rm -f /tmp/rubycocoahoge'
    @doc = REXML::Document.new(xml_src)
    @body = @doc.elements['html/body']
    elm_h1 = @body.elements['h1']
    if elm_h1 then
      @title = Uconv::u8toeuc(elm_h1.elements['a'].text)
    end
  end

  def to_s
    Uconv::u8toeuc(@body.to_s)
  end

  private

  def command(cmd)
    $stderr.puts "execute '#{cmd}' ..."
    raise(RuntimeError, cmd) unless system(cmd)
  end

  def rd2(src, dst, lang, css = nil, charset = nil)
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
    cmdstr = "rd2 -r rd/rd2html-lib #{opt_css} #{opt_charset} #{opt_lang}"
    command "#{cmdstr} #{src} > #{dst}"
  end

end
