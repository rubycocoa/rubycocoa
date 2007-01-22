# Created by Eloy Duran
# Copyright (c) 2007 Eloy Duran, SuperAlloy

class String
  
  # FIXME: At the moment this is only used by a method that cleans
  # a obj-c method description. It might be possible that we
  # can also just use the normal clean_up method, but I haven't
  # tested this yet...
  def unescape_chars
    self.gsub(/&lt;/, "<")
  end
  
  # FIXME: At the moment this is only used by a method that cleans
  # a obj-c method description. It might be possible that we
  # can also just use the normal clean_up method, but I haven't
  # tested this yet...
  def clean_special_chars
    self.gsub(/ /, ' ')
  end
  
  # Remove any html tags and it's contents
  def strip_tags
    self.gsub(/<\/?[^>]*>/, "")
  end
  
  # Convert obj-c types to ruby types
  def convert_types
    str = self
    
    # Replace the objc BOOL style with the ruby style
    str = str.gsub(/YES/, 'true')
    str = str.gsub(/NO/, 'false')
    
    return str
  end
  
  # Convert html tags that to code that rdoc uses for markup etc.
  def convert_tags
    str = self
    
    # Convert code elements
    str = str.gsub(/<code>/, 'TWOPEN').gsub(/<\/code>/, 'TWCLOSE')
    
    # Convert italic style from the parameters section
    str = str.gsub(/<dt><i>/, '_')
    str = str.gsub(/<\/i><\/dt>/, '_ ')
    
    # Convert italic style
    str = str.gsub(/<i>/, '_')
    return str
  end
  
  def clean_up
    str = self
    str = str.gsub(/\n/, ' ')
    str = str.strip_tags
    str = str.gsub(/TWOPEN/, '<tt>').gsub(/TWCLOSE/, '</tt>')
    str = str.gsub(/&#8211;|&#xA0;/, '')
    str = str.gsub(/“/, '<em>').gsub(/”/, '</em>')
    str = str.gsub(/–/, '-').gsub(/—/, '-')
    str = str.gsub(/’/, "'")
    str = str.gsub(/ /, ' ')
    str = str.gsub(/…/, '...')
     
    str = str.strip
    return str
  end
end
