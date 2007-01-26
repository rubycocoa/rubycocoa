class String
  def to_rb_def
    self.strip_tags.clean_up.gsub(/\(\w+\)/, '').strip.split(':').join('_')
  end
  
  def clean_objc
    self.clean_special_chars.strip_tags.unescape_chars.strip_tags
  end
  
  def rdocify
    self.convert_types.convert_tags.clean_up
  end
end

module Hpricot
  class Elem
    def fits_the_description?(tag, text)
      self.name == tag and self.inner_html.include?(text)
    end
    def spaceabove?
      self.get_attribute('class') == 'spaceabove'
    end
    def spaceabovemethod?
      self.get_attribute('class') == 'spaceabovemethod'
    end
    def spacer?
      self.spaceabove? or self.spaceabovemethod?
    end
  end
end
