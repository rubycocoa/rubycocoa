#
# $Id: TMDocument.rb,v 1.4 2005/11/23 15:02:17 kimuraw Exp $
#
require 'osx/cocoa'
require 'TMWindowController'

class TMDocument < OSX::NSDocument

  ns_overrides 'readFromFile:ofType:',
    'makeWindowControllers'

  def initailize
    @content = nil
  end

  def readFromFile_ofType(path, type)
    if (nsstr = readfile(path))
      parse(nsstr)
      return true
    else
      return false
    end
  end

  def makeWindowControllers
    TMWindowController.alloc.initWithDocument(self)
  end
  
  # returns ruby string
  def string_at_page(page)
    return nil unless @content
    str = @content[page - 1]
  end

  def page_count
    return @content.to_a.size
  end

  private

  def parse(str)
    src = str
    if src.is_a? OSX::ObjcID
      src = src.UTF8String
    end
    src = src.sub(/(?:\r|\r\n|\n)+\z/, '')
    @content = src.split(/(?:\r|\r\n|\n){2,}/)
  end

  def readfile(path)
    val = nil
    data = OSX::NSData.dataWithContentsOfFile(path)
    [OSX::NSJapaneseEUCStringEncoding, 
     OSX::NSShiftJISStringEncoding,
     OSX::NSUTF8StringEncoding,
     OSX::NSISO2022JPStringEncoding,
    ].each do |encoding|
      nsstr = OSX::NSString.alloc.initWithData(data, :encoding, encoding)
      if nsstr 
        val = nsstr
        break
      end
    end 
    return val
  end
  
end

