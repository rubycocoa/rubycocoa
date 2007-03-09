#
#  JSService.rb
#  Jisho
#
#  Created by Laurent Sansonetti on 11/27/06.
#  Copyright (c) 2006 Apple Computer. All rights reserved.
#

class JSService < NSObject
  def initWithWindowController(controller)
    if init
      @windowController = controller
      self
    end
  end

  def translate_userData_error(pboard, data, error)
    types = pboard.types
    if types.containsObject?(NSStringPboardType)
      criterion = pboard.stringForType(NSStringPboardType)
      @windowController.searchField.setStringValue(criterion)
      @windowController.search(@windowController.searchField)
    end
  end
  addRubyMethod_withType('translate:userData:error:', '@@:@@^@')
end
