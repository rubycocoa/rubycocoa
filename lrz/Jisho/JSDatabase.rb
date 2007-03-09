#
#  JSDatabase.rb
#  Jisho
#
#  Created by Laurent Sansonetti on 11/24/06.
#  Copyright (c) 2006 Apple Computer. All rights reserved.
#

$KCODE = 'U'

class XML::Reader
  def next_text
    while (self.node_type != XML::Reader::TYPE_TEXT and self.read > 0); end
    self.value
  end
end

class JSSense
  attr_reader :pos, :text, :lang
  def initialize(pos, text, lang)
    @pos, @text, @lang = pos, text, lang
  end
end

class JSEntry  
  attr_accessor :kanji, :kana, :senses
  def initialize(kanji, kana, senses)
    @kanji, @kana, @senses = kanji, kana, senses
  end

  KANA_RE = /^kana/
  SENSE_RE = /^sense_(..)/
  POS_RE = /^\[\[([^\]]+)\]\]\s+/
  def self.from_index_doc(doc)
    kanji = doc[:kanji]
    kana, senses = [], []
    doc.keys.map { |x| x.to_s }.sort.each do |key|
      txt = doc[key]
      case key
      when SENSE_RE
        lang = $1
        ary = txt.scan(POS_RE)
        senses << if ary.size == 1
          pos = ary.to_s
          JSSense.new(pos, txt[(pos.length + 4)..-1].strip, lang) 
        else
          JSSense.new(nil, txt.strip, lang)
        end
      when KANA_RE
        kana << txt.strip
      end
    end
    self.new(kanji, kana, senses)
  end

  def senses_by_lang(lang)
    senses.select { |x| x.lang == lang }
  end

  def to_index_doc
    doc = { :kanji => kanji }
    kana.each_with_index { |x, i| doc["kana_#{i}".intern] = x }
    senses.each_with_index do |x, i| 
      s = ''
      s << "[[#{x.pos}]] " if x.pos
      s << x.text
      doc["sense_#{x.lang}_#{i}".intern] = s
    end
    return doc
  end
end

class JSDatabase
  include Ferret
  include FileUtils

  def initialize(dict_path, db_path)
    @entries_cache = {}
    @dict_path = dict_path
    @index_path = File.join(db_path, 'index')
    load_index
  end

  def search(term, lang='en')
    results = []
    query = 'kanji|' + (0..10).map { |x| "kana_#{x}|sense_#{lang}_#{x}" }.join('|') + ":\"#{term}\""
    @index.search_each(query) do |docid, score|
      element = @entries_cache[docid]
      if element.nil?
        element = JSEntry.from_index_doc(@index[docid].load)
        @entries_cache[docid] = element
      end
      # XXX ferret seems to have problems giving realistic scores for Unicode terms, 
      # so let's help it.
      if element.kanji == term or element.kana.any? { |k| k == term }
        score = 1.0
      end
      results << [score, element]
    end
    results.sort { |x, y| y[0] <=> x[0] }.map { |x| x[1] }
  end

  def size
    @index.size
  end

  private

  def load_index
    analyzer = Analysis::PerFieldAnalyzer.new(Analysis::StandardAnalyzer.new)
    re_analyzer = Analysis::RegExpAnalyzer.new(/./, false)
    (0..10).map { |x| analyzer["kana_#{x}".intern] = re_analyzer }
    analyzer[:kanji] = re_analyzer 
    should_rebuild = !File.exists?(@index_path)
    @index = Index::Index.new(:path => @index_path, :analyzer => analyzer, :create => should_rebuild)
    rebuild_index if should_rebuild
  end

  def rebuild_index
    reader = nil
    Dir.chdir(NSTemporaryDirectory().to_s) do
      system("tar -xzf #{@dict_path}")
      reader = XML::Reader.file('JMdict')
    end
    reader.set_error_handler { |*a| p a }
    
    kanji, kana, senses = [], [], []
    glosses = {}
    pos = nil
    
    while reader.read > 0
      case reader.node_type
      when XML::Reader::TYPE_ELEMENT
        case reader.name
        when 'keb'
          kanji << reader.next_text
        when 'reb'
          kana << reader.next_text
        when 'gloss'
          (glosses[(reader['g_lang'] or 'en')] ||= []) << reader.next_text
=begin
        # Not needed for now.
        when 'pos'
          pos = reader.next_text
=end
        end
      when XML::Reader::TYPE_END_ELEMENT
        case reader.name
        when 'sense'
          glosses.each do |lang, texts| 
            senses << JSSense.new(pos, texts.join(', ').strip, lang)
          end
          glosses.clear
          pos = nil
        when 'entry'
          raise 'no kana!' if kana.empty?
          if kanji.empty?
            index_entry(nil, kana, senses)
          elsif kanji.size == 1 and kana.size > 0
            index_entry(kanji[0], kana, senses)
          elsif kana.size == 1 and kanji.size > 0
            kanji.each { |x| index_entry(x, kana[0], senses) }
          else
            len = [kana.size, kanji.size].min
            len.times { |i| index_entry(kanji[i], kana[i], senses) }
          end
          kanji.clear
          kana.clear
          senses.clear
        end
      end
    end
    @index.commit
  end

  def index_entry(kanji, kana, senses)
    @index << JSEntry.new(kanji, kana, senses).to_index_doc
  end
end