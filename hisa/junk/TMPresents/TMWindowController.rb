#
# $Id: TMWindowController.rb,v 1.17 2005/11/23 15:02:17 kimuraw Exp $
#
require 'osx/cocoa'
OSX.ns_import "AppleRemote"

module OSX
  unless defined? NSTornOffMenuWindowLevel
    NSTornOffMenuWindowLevel = 3 # CoreGraphics/CGWindowLevel.h
  end
end

class TMWindowController < OSX::NSWindowController

  WINDOW_AUTOSAVE_NAME = 'WINDOW DEFAULT FRAME'
  NOTIFY_PAGE_CHANGED = 'TMPageChanged'

  def initWithDocument(doc, start_page=1, full=false)
    @fullscreen = full
    win = setup_window(full)
    initWithWindow(win)
    doc.addWindowController(self)
    window.setDelegate(self)
    setup_responder_chain
    center.objc_send(:addObserver, self,
                     :selector, 'pageChanged:',
                     :name, NOTIFY_PAGE_CHANGED, :object, doc)
    r = OSX::AppleRemote.sharedRemote
    r.setDelegate(self)
    r.startListening(self)
    _go(start_page)
    return self
  end

  # 5:left 0:up 4:right 1:bot 3:play  2:menu
  def appleRemoteButton_pressedDown(buttonIdentifier, pressedDown)
    case buttonIdentifier
    when 0 then goToFirst(self)
    when 1 then goToLast(self)
    when 2 then ;
    when 3 then evalPage(self)
    when 4 then goToNext(self)
    when 5 then goToPrev(self)
    end
  end
  objc_method :appleRemoteButton_pressedDown, [:void, :int, :bool]

  def reloadDocument(sender)
    document.readFromFile_ofType(document.fileName, document.fileType)
    go(@page)
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
    notif = OSX::NSNotification.
      objc_send( :notificationWithName, NOTIFY_PAGE_CHANGED,
                 :object, document, :userInfo, {'page' => new_page} )
    center.postNotification(notif)
  end

  def _go(new_page)
    return unless document
    ResultView.instance.hide
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
      win = TMFullScreenWindow.alloc.
        objc_send( :initWithContentRect, rect,
                   :styleMask, OSX::NSBorderlessWindowMask,
                   :backing, OSX::NSBackingStoreBuffered,
                   :defer, true )
      win.setLevel(OSX::NSTornOffMenuWindowLevel)
    else
      rect = [100, 200, 400, 300] # temporaly frame
      win = OSX::NSWindow.alloc.
        objc_send( :initWithContentRect, rect,
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

  def evalPage(sender)
    rv = ResultView.instance
    str = document.string_at_page(@page)
    result = eval(str, TOPLEVEL_BINDING)
    rv = ResultView.instance
    rv.text = OSX::NSString.stringWithString(result.to_s)
    rv.show
    OSX.NSLog("evalPage(%@) => %@", @page, result)
  rescue Exception => err
    rv = ResultView.instance
    msg = "ERROR!\n" << err.message
    rv.text = OSX::NSString.stringWithString(msg)
    rv.show
    OSX.NSLog("evalPage(%@) -- error %@", @page, err.message)
  end

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

  def canBecomeKeyWindow
    return true
  end

end

class String

  def to_nsstr
    OSX::NSString.stringWithUTF8String(self)
  end

end
