/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
 *
 *   This program is free software.
 *   You can distribute/modify this program under the terms of
 *   the GNU Lesser General Public License version 2.
 *
 **/
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSException.h>
#import <Foundation/NSString.h>
#import "osx_ruby.h"
#import "ocdata_conv.h"

static VALUE
_ocdataconv_err_class()
{
  static VALUE exc = Qnil;
  if (exc == Qnil) {
    VALUE mosx = rb_const_get(rb_cObject, rb_intern("OSX"));
    exc = rb_const_get(mosx, rb_intern("OCDataConvException"));
  }
  return exc;
}

static VALUE
_oc_err_class()
{
  static VALUE exc = Qnil;
  if (exc == Qnil) {
    VALUE mosx = rb_const_get(rb_cObject, rb_intern("OSX"));
    exc = rb_const_get(mosx, rb_intern("OCException"));
  }
  return exc;
}

VALUE
oc_err_new (const char* fname, NSException* nsexcp)
{
  id pool = [[NSAutoreleasePool alloc] init];
  VALUE exc = _oc_err_class();
  char buf[BUFSIZ];
  VALUE result;

  snprintf(buf, BUFSIZ, "%s - %s - %s", fname,
	   [[nsexcp name] cString], [[nsexcp reason] cString]);
  result = rb_funcall(exc, rb_intern("new"), 2, ocid_to_rbobj(Qnil, nsexcp), rb_str_new2(buf));
  [pool release];
  return result;
}

void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(_ocdataconv_err_class(), "%s - arg #%d cannot convert to nsobj.", fname, index);
  }
}

VALUE
nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool)
{
  VALUE rbresult;
  if (!ocdata_to_rbobj(Qnil, octype, nsresult, &rbresult)) {
    if (pool) [pool release];
    rb_raise(_ocdataconv_err_class(), "%s - result cannot convert to rbobj.", fname);
  }
  return rbresult;
}

extern void init_NSAppleEventManager(VALUE);
extern void init_NSAppleScript(VALUE);
extern void init_NSApplication(VALUE);
extern void init_NSArchiver(VALUE);
extern void init_NSAttributedString(VALUE);
extern void init_NSBezierPath(VALUE);
extern void init_NSBitmapImageRep(VALUE);
extern void init_NSBox(VALUE);
extern void init_NSBundle(VALUE);
extern void init_NSButtonCell(VALUE);
extern void init_NSByteOrder(VALUE);
extern void init_NSCell(VALUE);
extern void init_NSCharacterSet(VALUE);
extern void init_NSClassDescription(VALUE);
extern void init_NSCoder(VALUE);
extern void init_NSColor(VALUE);
extern void init_NSColorList(VALUE);
extern void init_NSColorPanel(VALUE);
extern void init_NSComboBox(VALUE);
extern void init_NSConnection(VALUE);
extern void init_NSControl(VALUE);
extern void init_NSDecimal(VALUE);
extern void init_NSDecimalNumber(VALUE);
extern void init_NSDistributedNotificationCenter(VALUE);
extern void init_NSDocument(VALUE);
extern void init_NSDragging(VALUE);
extern void init_NSDrawer(VALUE);
extern void init_NSErrors(VALUE);
extern void init_NSEvent(VALUE);
extern void init_NSException(VALUE);
extern void init_NSFileHandle(VALUE);
extern void init_NSFileManager(VALUE);
extern void init_NSFont(VALUE);
extern void init_NSFontManager(VALUE);
extern void init_NSFontPanel(VALUE);
extern void init_NSGeometry(VALUE);
extern void init_NSGlyphInfo(VALUE);
extern void init_NSGraphics(VALUE);
extern void init_NSGraphicsContext(VALUE);
extern void init_NSHFSFileTypes(VALUE);
extern void init_NSHashTable(VALUE);
extern void init_NSHelpManager(VALUE);
extern void init_NSImage(VALUE);
extern void init_NSImageCell(VALUE);
extern void init_NSImageRep(VALUE);
extern void init_NSInterfaceStyle(VALUE);
extern void init_NSInvocation(VALUE);
extern void init_NSJavaSetup(VALUE);
extern void init_NSKeyedArchiver(VALUE);
extern void init_NSLayoutManager(VALUE);
extern void init_NSMapTable(VALUE);
extern void init_NSMatrix(VALUE);
extern void init_NSMenu(VALUE);
extern void init_NSMovieView(VALUE);
extern void init_NSNetServices(VALUE);
extern void init_NSNotificationQueue(VALUE);
extern void init_NSObjCRuntime(VALUE);
extern void init_NSObject(VALUE);
extern void init_NSOpenGL(VALUE);
extern void init_NSOutlineView(VALUE);
extern void init_NSPageLayout(VALUE);
extern void init_NSPanel(VALUE);
extern void init_NSParagraphStyle(VALUE);
extern void init_NSPasteboard(VALUE);
extern void init_NSPathUtilities(VALUE);
extern void init_NSPopUpButton(VALUE);
extern void init_NSPopUpButtonCell(VALUE);
extern void init_NSPort(VALUE);
extern void init_NSPrintInfo(VALUE);
extern void init_NSPrintOperation(VALUE);
extern void init_NSPrintPanel(VALUE);
extern void init_NSPrinter(VALUE);
extern void init_NSProcessInfo(VALUE);
extern void init_NSProgressIndicator(VALUE);
extern void init_NSPropertyList(VALUE);
extern void init_NSRange(VALUE);
extern void init_NSRulerView(VALUE);
extern void init_NSRunLoop(VALUE);
extern void init_NSSavePanel(VALUE);
extern void init_NSScriptCommand(VALUE);
extern void init_NSScriptKeyValueCoding(VALUE);
extern void init_NSScriptObjectSpecifiers(VALUE);
extern void init_NSScriptStandardSuiteCommands(VALUE);
extern void init_NSScriptWhoseTests(VALUE);
extern void init_NSScroller(VALUE);
extern void init_NSSliderCell(VALUE);
extern void init_NSSound(VALUE);
extern void init_NSSplitView(VALUE);
extern void init_NSString(VALUE);
extern void init_NSTabView(VALUE);
extern void init_NSTabViewItem(VALUE);
extern void init_NSTableView(VALUE);
extern void init_NSTask(VALUE);
extern void init_NSText(VALUE);
extern void init_NSTextAttachment(VALUE);
extern void init_NSTextContainer(VALUE);
extern void init_NSTextFieldCell(VALUE);
extern void init_NSTextStorage(VALUE);
extern void init_NSTextView(VALUE);
extern void init_NSThread(VALUE);
extern void init_NSToolbar(VALUE);
extern void init_NSToolbarItem(VALUE);
extern void init_NSURL(VALUE);
extern void init_NSURLHandle(VALUE);
extern void init_NSUndoManager(VALUE);
extern void init_NSUserDefaults(VALUE);
extern void init_NSView(VALUE);
extern void init_NSWindow(VALUE);
extern void init_NSWorkspace(VALUE);
extern void init_NSZone(VALUE);

void init_cocoa(VALUE mOSX)
{
  init_NSAppleEventManager(mOSX);
  init_NSAppleScript(mOSX);
  init_NSApplication(mOSX);
  init_NSArchiver(mOSX);
  init_NSAttributedString(mOSX);
  init_NSBezierPath(mOSX);
  init_NSBitmapImageRep(mOSX);
  init_NSBox(mOSX);
  init_NSBundle(mOSX);
  init_NSButtonCell(mOSX);
  init_NSByteOrder(mOSX);
  init_NSCell(mOSX);
  init_NSCharacterSet(mOSX);
  init_NSClassDescription(mOSX);
  init_NSCoder(mOSX);
  init_NSColor(mOSX);
  init_NSColorList(mOSX);
  init_NSColorPanel(mOSX);
  init_NSComboBox(mOSX);
  init_NSConnection(mOSX);
  init_NSControl(mOSX);
  init_NSDecimal(mOSX);
  init_NSDecimalNumber(mOSX);
  init_NSDistributedNotificationCenter(mOSX);
  init_NSDocument(mOSX);
  init_NSDragging(mOSX);
  init_NSDrawer(mOSX);
  init_NSErrors(mOSX);
  init_NSEvent(mOSX);
  init_NSException(mOSX);
  init_NSFileHandle(mOSX);
  init_NSFileManager(mOSX);
  init_NSFont(mOSX);
  init_NSFontManager(mOSX);
  init_NSFontPanel(mOSX);
  init_NSGeometry(mOSX);
  init_NSGlyphInfo(mOSX);
  init_NSGraphics(mOSX);
  init_NSGraphicsContext(mOSX);
  init_NSHFSFileTypes(mOSX);
  init_NSHashTable(mOSX);
  init_NSHelpManager(mOSX);
  init_NSImage(mOSX);
  init_NSImageCell(mOSX);
  init_NSImageRep(mOSX);
  init_NSInterfaceStyle(mOSX);
  init_NSInvocation(mOSX);
  init_NSJavaSetup(mOSX);
  init_NSKeyedArchiver(mOSX);
  init_NSLayoutManager(mOSX);
  init_NSMapTable(mOSX);
  init_NSMatrix(mOSX);
  init_NSMenu(mOSX);
  init_NSMovieView(mOSX);
  init_NSNetServices(mOSX);
  init_NSNotificationQueue(mOSX);
  init_NSObjCRuntime(mOSX);
  init_NSObject(mOSX);
  init_NSOpenGL(mOSX);
  init_NSOutlineView(mOSX);
  init_NSPageLayout(mOSX);
  init_NSPanel(mOSX);
  init_NSParagraphStyle(mOSX);
  init_NSPasteboard(mOSX);
  init_NSPathUtilities(mOSX);
  init_NSPopUpButton(mOSX);
  init_NSPopUpButtonCell(mOSX);
  init_NSPort(mOSX);
  init_NSPrintInfo(mOSX);
  init_NSPrintOperation(mOSX);
  init_NSPrintPanel(mOSX);
  init_NSPrinter(mOSX);
  init_NSProcessInfo(mOSX);
  init_NSProgressIndicator(mOSX);
  init_NSPropertyList(mOSX);
  init_NSRange(mOSX);
  init_NSRulerView(mOSX);
  init_NSRunLoop(mOSX);
  init_NSSavePanel(mOSX);
  init_NSScriptCommand(mOSX);
  init_NSScriptKeyValueCoding(mOSX);
  init_NSScriptObjectSpecifiers(mOSX);
  init_NSScriptStandardSuiteCommands(mOSX);
  init_NSScriptWhoseTests(mOSX);
  init_NSScroller(mOSX);
  init_NSSliderCell(mOSX);
  init_NSSound(mOSX);
  init_NSSplitView(mOSX);
  init_NSString(mOSX);
  init_NSTabView(mOSX);
  init_NSTabViewItem(mOSX);
  init_NSTableView(mOSX);
  init_NSTask(mOSX);
  init_NSText(mOSX);
  init_NSTextAttachment(mOSX);
  init_NSTextContainer(mOSX);
  init_NSTextFieldCell(mOSX);
  init_NSTextStorage(mOSX);
  init_NSTextView(mOSX);
  init_NSThread(mOSX);
  init_NSToolbar(mOSX);
  init_NSToolbarItem(mOSX);
  init_NSURL(mOSX);
  init_NSURLHandle(mOSX);
  init_NSUndoManager(mOSX);
  init_NSUserDefaults(mOSX);
  init_NSView(mOSX);
  init_NSWindow(mOSX);
  init_NSWorkspace(mOSX);
  init_NSZone(mOSX);
}
