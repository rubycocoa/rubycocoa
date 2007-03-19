#
# $Id: TMDefaultsController.rb,v 1.4 2005/12/12 15:15:52 kimuraw Exp $
#
require 'osx/cocoa'

class TMDefaultsController < OSX::NSUserDefaultsController

  ns_overrides 'initWithCoder:', 'valueForKeyPath:'

  # dependency set to NSUserDefaults
  OSX::NSUserDefaults.instance_eval <<-KVC_DEPENDENCY
    self.extend OSX::NSKVCBehaviorAttachment
    kvc_depends_on :textFontName, :displayTextFontName
  KVC_DEPENDENCY

  @@shared = nil

  def self.sharedUserDefaultsController
    return @@shared if @@shared
    @@shared = self.alloc.initWithDefaults(nil,
      :initialValues, 
      {'textColor' => archive(OSX::NSColor.blackColor),
       'textFontName' => 'HiraKakuPro-W6',
       'backgroundColor' => archive(OSX::NSColor.whiteColor),
       'keepBottomSpace' => 0})
  end

  def initWithCoder(coder)
    TMDefaultsController.sharedUserDefaultsController
  end

  def valueForKeyPath(path)
    compo = path.to_s.split(/\./, 3)
    if compo.size > 2 and need_archive?(compo[1])
      value = self[compo[1]].valueForKeyPath(compo[2])
    elsif compo.size > 1 and display_fontname_key?(compo[1])
      value = display_fontname(compo[1])
    else
      value = super_valueForKeyPath(path)
    end
    return value
  end

  def [](key)
    value = valueForKeyPath("values.#{key.to_s}")
    if need_archive?(key)
      value = unarchive(value)
    end
    return value
  end

  def []=(key, value)
    if need_archive?(key)
      setValue_forKeyPath(archive(value), "values.#{key.to_s}")
    else
      setValue_forKeyPath(value, "values.#{key.to_s}")
    end
  end

  private
  def need_archive?(key)
    if /(Color|Font)\z/ =~ key.to_s
      return true
    else
      return false
    end
  end

  # "displayTextFontName" => true
  def display_fontname_key?(key)
    if /\Adisplay\w+FontName\z/ =~ key.to_s
      return true
    else
      return false
    end
  end

  def display_fontname(key)
    font_key = key.to_s.sub(/\Adisplay/, '')
    font_key = font_key[0..0].downcase + font_key[1..-1]
    font = OSX::NSFont.fontWithName(self[font_key], :size, 12.0)
    if font
      font.displayName
    else
      nil
    end
  end

  def self.archive(obj)
    OSX::NSArchiver.archivedDataWithRootObject(obj)
  end

  def archive(obj)
    self.class.archive(obj)
  end

  def unarchive(data)
    OSX::NSUnarchiver.unarchiveObjectWithData(data)
  end

end

