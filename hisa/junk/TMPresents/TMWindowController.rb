#
# $Id: TMWindowController.rb,v 1.17 2005/11/23 15:02:17 kimuraw Exp $
#
require 'osx/cocoa'

module OSX
  unless defined? NSTornOffMenuWindowLevel
    NSTornOffMenuWindowLevel = 3 # CoreGraphics/CGWindowLevel.h
  end
end

class TMWindowController < OSX::NSWindowController
  ns_overrides 'windowTitleForDocumentDisplayName:',
    'dealloc'

  WINDOW_AUTOSAVE_NAME = 'WINDOW DEFAULT FRAME'
  NOTIFY_PAGE_CHANGED = 'TMPageChanged'

  def initWithDocument(doc, start_page=1, full=false)
    @fullscreen = full
    win = setup_window(full)
    initWithWindow(win)
    doc.addWindowController(self)
    window.setDelegate(self)
    setup_responder_chain
    center.addObserver(self, :selector, 'pageChanged:',
      :name, NOTIFY_PAGE_CHANGED, :object, doc)
    _go(start_page)
    return self
  end

  def reloadDocument(sender)
    document.readFromFile_ofType(document.fileName, document.fileType)
    _go(@page)
  end

  def windowTitleForDocumentDisplayName(disp_name)
    return disp_name unless @page
    page_info = '(%d/%d)' % [@page, document.page_count]
    return disp_name.stringByAppendingString(page_info.to_nsstr)
  end

  def startFullScreen(sender)
    return if @fullscreen

    full_ctl = TMWindowController.alloc.initWithDocument(document, @page, true)
    full_ctl.window.makeKeyAndOrderFront(sender)
  end

  def stopFullScreen(sender)
    return unless @fullscreen

    full_deactivate
    window.close
    synchronizeWindowTitleWithDocumentName
  end

  def windowWillClose(notification)
    window.saveFrameUsingName(WINDOW_AUTOSAVE_NAME) unless @fullscreen
  end

  def windowDidResignKey(notification)
    full_deactivate if @fullscreen
  end

  def windowDidBecomeKey(notification)
    full_activate if @fullscreen
  end

  def dealloc
    center.removeObserver(self)
    super_dealloc
  end

  def pageChanged(notification)
    new_page = notification.userInfo.objectForKey('page').to_i
    return if new_page == @page
    _go(new_page)
  end

  private

  def go(new_page)
    _go(new_page)
    notif = OSX::NSNotification.notificationWithName(NOTIFY_PAGE_CHANGED,
      :object, document, :userInfo, {'page' => new_page})
    center.postNotification(notif)
  end

  def _go(new_page)
    return unless document
    if new_page <= 0 then
      new_page = 1
    elsif new_page > document.page_count
      return # stay last page
    end
    @page = new_page
    str = document.string_at_page(@page)
    window.contentView.unformat_text = str
    synchronizeWindowTitleWithDocumentName
  end

  def setup_window(full)
    if full
      rect = OSX::NSScreen.mainScreen.frame
      win = TMFullScreenWindow.alloc.initWithContentRect(rect,
	:styleMask, OSX::NSBorderlessWindowMask,
	:backing, OSX::NSBackingStoreBuffered,
	:defer, true)
      win.setLevel(OSX::NSTornOffMenuWindowLevel)
    else
      rect = [100, 200, 400, 300] # temporaly frame
      win = OSX::NSWindow.alloc.initWithContentRect(rect,
	:styleMask, normal_mask,
	:backing, OSX::NSBackingStoreBuffered,
	:defer, true)
      win.setFrameUsingName(WINDOW_AUTOSAVE_NAME)
    end
    view = TMView.alloc.initWithFrame(win.contentView.bounds)
    win.setContentView(view)
    return win
  end
  
  def normal_mask
    return OSX::NSTitledWindowMask |
      OSX::NSClosableWindowMask |
      OSX::NSMiniaturizableWindowMask |
      OSX::NSResizableWindowMask
  end

  def setup_responder_chain
    view = window.contentView
    window.makeFirstResponder(view)
    view.setNextResponder(self)
    self.setNextResponder(window)
    window.setNextResponder(nil)
  end

  def full_activate
    OSX::NSMenu.setMenuBarVisible(false)
    OSX::NSCursor.hide
    window.setLevel(OSX::NSTornOffMenuWindowLevel) 
  end

  def full_deactivate
    OSX::NSMenu.setMenuBarVisible(true)
    OSX::NSCursor.unhide
    window.setLevel(OSX::NSNormalWindowLevel) 
  end

  # utility
  def center
    OSX::NSNotificationCenter.defaultCenter
  end

end

# page actions
class TMWindowController

  def goToNext(sender)
    go(@page + 1)
  end
  
  def goToPrev(sender)
    go(@page - 1)
  end
  
  def goToFirst(sender)
    go(1)
  end
  
  def goToLast(sender)
    go(document.page_count)
  end

end

class TMFullScreenWindow < OSX::NSWindow
  ns_overrides 'canBecomeKeyWindow'

  def canBecomeKeyWindow
    return true
  end

end

class String

  def to_nsstr
    OSX::NSString.stringWithUTF8String(self)
  end

end
