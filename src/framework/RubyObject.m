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
#import "RubyObject.h"

#import <LibRuby/cocoa_ruby.h>
#import <Cocoa/Cocoa.h>
#import <stdarg.h>
#import "ocdata_conv.h"


#define OCID2NUM(val) UINT2NUM((VALUE)(val))

#undef DEBUGLOG

#ifdef DEBUGLOG
#  define DLOG(f)            NSLog((f))
#  define DLOG1(f,a0)        NSLog((f),(a0))
#  define DLOG2(f,a0,a1)     NSLog((f),(a0),(a1))
#  define DLOG3(f,a0,a1,a2)) NSLog((f),(a0),(a1),(a2))
#else
#  define DLOG(f)
#  define DLOG1(f,a0)
#  define DLOG2(f,a0,a1)
#  define DLOG3(f,a0,a1,a2))
#endif

static VALUE to_rbobj(id ocobj)
{
  VALUE mOSX = rb_const_get(rb_cObject, rb_intern("OSX"));
  VALUE cOCObject = rb_const_get(mOSX, rb_intern("OCObject"));
  return rb_funcall(cOCObject, rb_intern("new_with_id"), 1, OCID2NUM(ocobj));
}

static id to_nsobj(VALUE rbobj)
{
  id nsobj;
  if (rbobj_to_nsobj(rbobj, &nsobj))
    return nsobj;
  return nil;
}

static RB_ID sel_to_mid(SEL a_sel)
{
  int i;
  id pool;
  NSString* selstr;
  char mname[1024];

  pool = [[NSAutoreleasePool alloc] init];
  selstr = NSStringFromSelector(a_sel);
  [selstr getCString: mname maxLength: sizeof(mname)];

  /** s/:/_/ and s/^(.*)_$/\1/ **/
  for (i = 0; i < [selstr length]; i++)
    if (mname[i] == ':') mname[i] = '_';
  if (mname[[selstr length]-1] == '_')
    mname[[selstr length]-1] = '\0';
  [pool release];

  return rb_intern(mname);
}

static SEL dummy_selector_of(SEL a_sel)
{
  id selstr;
  SEL newsel;
  id pool = [[NSAutoreleasePool alloc] init];
  selstr = NSStringFromSelector(a_sel);
  selstr = [@"dummy_" stringByAppendingString: selstr];
  newsel = NSSelectorFromString(selstr);
  [pool release];
  return newsel;
}

@implementation RubyObject

/*********************/
/** private methods **/
/*********************/

- (BOOL) hasObjcHandlerOf: (SEL)a_sel
{
  return [super respondsToSelector: a_sel];
}

- (BOOL) hasRubyHandlerOf: (SEL)a_sel
{
  RB_ID mid = sel_to_mid(a_sel);
  return (rb_respond_to(rbobj, mid) != 0);
}

- (NSMethodSignature *)msigForRubyMethod: (SEL)a_sel
{
  if ([self hasRubyHandlerOf: a_sel]) {
    a_sel = dummy_selector_of(a_sel);
    return [self methodSignatureForSelector: a_sel];
  }
  return nil;
}

- (VALUE) forwardArgumentsOf: (NSInvocation*)an_inv
{
  int i;
  NSMethodSignature* msig = [an_inv methodSignature];
  int arg_cnt = ([msig numberOfArguments] - 2);
  VALUE args = rb_ary_new2(arg_cnt);
  for (i = 0; i < arg_cnt; i++) {
    VALUE arg_val;
    const char* octstr = [msig getArgumentTypeAtIndex: (i+2)];
    int octype = to_octype(octstr);
    void* ocdata = ocdata_malloc(octype);
    BOOL f_conv_success;
    [an_inv getArgument: ocdata atIndex: (i+2)];
    if ((octype == _C_ID) || (octype == _C_CLASS)) {
      id ocid = *(id*)ocdata;
      arg_val = (ocid == self) ? rbobj : to_rbobj(ocid);
      f_conv_success = YES;
    }
    else {
      f_conv_success = ocdata_to_rbobj(octype, ocdata, &arg_val);
    }
    free(ocdata);
    if (f_conv_success == NO) {
      arg_val = Qnil;
    }
    rb_ary_store(args, i, arg_val);
  }
  return args;
}

- (void) setForwardResult: (VALUE) result to:(NSInvocation*)an_inv
{
  NSMethodSignature* msig = [an_inv methodSignature];
  int octype = to_octype([msig methodReturnType]);
  void* ocdata = ocdata_malloc(octype);
  BOOL f_conv_success = rbobj_to_ocdata (result, octype, ocdata);
  if (f_conv_success)
    [an_inv setReturnValue: ocdata];
  free(ocdata);
}

- (void) forwardToRuby: (NSInvocation*)an_inv
{
  VALUE rb_args;
  VALUE rb_result;
  RB_ID mid = sel_to_mid([an_inv selector]);
  if (!rb_respond_to(rbobj, mid)) return;
  rb_args = [self forwardArgumentsOf: an_inv];
  rb_result = rb_apply(rbobj, mid, rb_args);
  [self setForwardResult: rb_result to: an_inv];
}

/********************/
/** public methods **/
/********************/

- init
{
  id pool = [[NSAutoreleasePool alloc] init];
  [self initWithRubyClassName: [[self class] description]];
  [pool release];
  return self;
}

- initWithRubyObject: (unsigned long) a_rbobj
{
  rbobj = a_rbobj;
  return self;
}

- initWithRubyClassName: class_name
{
  RB_ID rb_class_id;
  VALUE rb_class;

  rb_class_id = rb_intern([class_name cString]);
  rb_class = rb_const_get(rb_cObject, rb_class_id);
  // responds? new_with_id
  if (rb_respond_to(rb_class, rb_intern("new_with_id"))) {
    // OSX::OCObject
    rbobj = rb_funcall(rb_class, rb_intern("new_with_id"), 1, OCID2NUM(self));
  }
  else {
    rbobj = rb_funcall(rb_class, rb_intern("new"), 0);
    rb_funcall(rbobj, rb_intern("set_ocobj"), 1, to_rbobj(self));
  }
  return self;
}

- (BOOL) respondsToSelector: (SEL)a_sel
{
  DLOG1(@"== respondsToSelector(%@)", NSStringFromSelector(a_sel));
  if ([self hasObjcHandlerOf: a_sel]) return YES;
  return [self hasRubyHandlerOf: a_sel];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  NSMethodSignature* msig;
  DLOG1(@"== methodSignatureForSelector(%@)" , NSStringFromSelector(aSelector));
  msig = [super methodSignatureForSelector: aSelector];
  if (msig == nil) msig = [self msigForRubyMethod: aSelector];
  return msig;
}

- performSelector: (SEL)a_sel
{
  DLOG1(@"== performSelector:%@", NSStringFromSelector(a_sel));
  if ([self hasObjcHandlerOf: a_sel]) {
    return [super performSelector: a_sel];
  }
  else {
    RB_ID mid = sel_to_mid(a_sel);
    if (rb_respond_to(rbobj, mid)) {
      VALUE rb_result = rb_funcall(rbobj, mid, 0);
      return to_nsobj(rb_result);
    }
  }
  return nil;
}

- performSelector: (SEL)a_sel withObject: arg0
{
  DLOG1(@"== performSelector:%@:", NSStringFromSelector(a_sel));
  if ([self hasObjcHandlerOf: a_sel]) {
    return [super performSelector: a_sel];
  }
  else {
    RB_ID mid = sel_to_mid(a_sel);
    if (rb_respond_to(rbobj, mid)) {
      VALUE rb_result = rb_funcall(rbobj, mid, 1, to_rbobj(arg0));
      return to_nsobj(rb_result);
    }
  }
  return nil;
}

- performSelector: (SEL)a_sel withObject: arg0 withObject: arg1
{
  DLOG1(@"== performSelector:%@::", NSStringFromSelector(a_sel));
  if ([self hasObjcHandlerOf: a_sel]) {
    return [super performSelector: a_sel];
  }
  else {
    RB_ID mid = sel_to_mid(a_sel);
    if (rb_respond_to(rbobj, mid)) {
      VALUE rb_result = rb_funcall(rbobj, mid, 2, to_rbobj(arg0), to_rbobj(arg1));
      return to_nsobj(rb_result);
    }
  }
  return nil;
}

- (void) forwardInvocation: (NSInvocation *)an_inv
{
  SEL a_sel = [an_inv selector];
  DLOG1(@"== forwardInvocation(%@)", an_inv);
  if ([self hasObjcHandlerOf: a_sel]) {
    [super forwardInvocation: an_inv];
  }
  else {
    [self forwardToRuby: an_inv];
  }
}


/************************/
/** informal protocols **/
/************************/

// @interface NSObject (NSNibAwaking)
- (void)dummy_awakeFromNib {}

// @interface NSObject (NSConnectionDelegateMethods)
- (BOOL)dummy_makeNewConnection:(NSConnection *)conn sender:(NSConnection *)ancestor { return NO; }
- (BOOL)dummy_connection:(NSConnection *)ancestor shouldMakeNewConnection:(NSConnection *)conn { return NO; }
- (NSData *)dummy_authenticationDataForComponents:(NSArray *)components { return nil; }
- (BOOL)dummy_authenticateComponents:(NSArray *)components withData:(NSData *)signature { return NO; }
- (id)dummy_createConversationForConnection:(NSConnection *)conn { return nil; }

// @interface NSObject (NSPortDelegateMethods)
- (void)dummy_handlePortMessage:(NSPortMessage *)message {}

// @interface NSObject (NSMachPortDelegateMethods)
- (void)dummy_handleMachMessage:(void *)msg {}

// @interface NSObject(NSSpellServerDelegate)
- (NSRange)dummy_spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language wordCount:(int *)wordCount countOnly:(BOOL)countOnly { NSRange dummy = {0,0}; return dummy; }
- (NSArray *)dummy_spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word inLanguage:(NSString *)language { return nil; }
- (void)dummy_spellServer:(NSSpellServer *)sender didLearnWord:(NSString *)word inLanguage:(NSString *)language {}
- (void)dummy_spellServer:(NSSpellServer *)sender didForgetWord:(NSString *)word inLanguage:(NSString *)language {}

// @interface NSObject(NSBrowserDelegate)
- (int)dummy_browser:(NSBrowser *)sender numberOfRowsInColumn:(int)column { return 0; }
- (void)dummy_browser:(NSBrowser *)sender createRowsForColumn:(int)column inMatrix:(NSMatrix *)matrix {}
- (void)dummy_browser:(NSBrowser *)sender willDisplayCell:(id)cell atRow:(int)row column:(int)column {}
- (NSString *)dummy_browser:(NSBrowser *)sender titleOfColumn:(int)column { return nil; }
- (BOOL)dummy_browser:(NSBrowser *)sender selectCellWithString:(NSString *)title inColumn:(int)column { return NO; }
- (BOOL)dummy_browser:(NSBrowser *)sender selectRow:(int)row inColumn:(int)column { return NO; }
- (BOOL)dummy_browser:(NSBrowser *)sender isColumnValid:(int)column { return NO; }
- (void)dummy_browserWillScroll:(NSBrowser *)sender {}
- (void)dummy_browserDidScroll:(NSBrowser *)sender {}

// @interface NSObject(NSControlSubclassDelegate)
- (BOOL)dummy_control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor { return NO; }
- (BOOL)dummy_control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor { return NO; }
- (BOOL)dummy_control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error { return NO; }
- (void)dummy_control:(NSControl *)control didFailToValidatePartialString:(NSString *)string errorDescription:(NSString *)error {}
- (BOOL)dummy_control:(NSControl *)control isValidObject:(id)obj { return NO; }

- (BOOL)dummy_control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector { return NO; }

// @interface NSObject(NSDrawerDelegate)
- (BOOL)dummy_drawerShouldOpen:(NSDrawer *)sender { return NO; }
- (BOOL)dummy_drawerShouldClose:(NSDrawer *)sender { return NO; }
- (NSSize)dummy_drawerWillResizeContents:(NSDrawer *)sender toSize:(NSSize)contentSize { NSSize s = {0.0,0.0}; return s; }

// @interface NSObject(NSFontManagerDelegate)
- (BOOL)dummy_fontManager:(id)sender willIncludeFont:(NSString *)fontName { return NO; }

// @interface NSObject(NSImageDelegate)
- (NSImage *)dummy_imageDidNotDraw:(id)sender inRect:(NSRect)aRect { return nil; }

// @interface NSObject (NSLayoutManagerDelegate)
- (void)dummy_layoutManagerDidInvalidateLayout:(NSLayoutManager *)sender {}
- (void)dummy_layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {}

// @interface NSObject(NSOutlineViewDelegate)
- (void)dummy_outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {}
- (BOOL)dummy_outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item { return NO; }
- (BOOL)dummy_selectionShouldChangeInOutlineView:(NSOutlineView *)outlineView { return NO; }
- (BOOL)dummy_outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item { return NO; }
- (BOOL)dummy_outlineView:(NSOutlineView *)outlineView shouldSelectTableColumn:(NSTableColumn *)tableColumn { return NO; }
- (BOOL)dummy_outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item { return NO; }
- (BOOL)dummy_outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item { return NO; }
- (void)dummy_outlineView:(NSOutlineView *)outlineView willDisplayOutlineCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {}

// @interface NSObject(NSSavePanelDelegate)
- (NSString *)dummy_panel:(id)sender userEnteredFilename:(NSString *)filename confirmed:(BOOL)okFlag { return nil; }
- (BOOL)dummy_panel:(id)sender isValidFilename:(NSString *)filename { return NO; }
- (BOOL)dummy_panel:(id)sender shouldShowFilename:(NSString *)filename { return NO; }
- (NSComparisonResult)dummy_panel:(id)sender compareFilename:(NSString *)file1 with:(NSString *)file2 caseSensitive:(BOOL)caseSensitive { return NSOrderedSame; }
- (void)dummy_panel:(id)sender willExpand:(BOOL)expanding {}

// @interface NSObject (NSSoundDelegateMethods)
- (void)dummy_sound:(NSSound *)sound didFinishPlaying:(BOOL)aBool {}

// @interface NSObject(NSSplitViewDelegate)
- (void)dummy_splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize {}
- (float)dummy_splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedCoord ofSubviewAt:(int)offset { return 0.0; }
- (float)dummy_splitView:(NSSplitView *)sender constrainMaxCoordinate:(float)proposedCoord ofSubviewAt:(int)offset { return 0.0; }
- (void)dummy_splitViewWillResizeSubviews:(NSNotification *)notification {}
- (void)dummy_splitViewDidResizeSubviews:(NSNotification *)notification {}
- (BOOL)dummy_splitView:(NSSplitView *)sender canCollapseSubview:(NSView *)subview { return NO; }
- (float)dummy_splitView:(NSSplitView *)splitView constrainSplitPosition:(float)proposedPosition ofSubviewAt:(int)index { return 0.0; }

// @interface NSObject(NSTabViewDelegate)
- (BOOL)dummy_tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem { return NO; }
- (void)dummy_tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem {}
- (void)dummy_tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {}
- (void)dummy_tabViewDidChangeNumberOfTabViewItems:(NSTabView *)TabView {}

// @interface NSObject(NSTableViewDelegate)
- (void)dummy_tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row {}
- (BOOL)dummy_tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(int)row { return NO; }
- (BOOL)dummy_selectionShouldChangeInTableView:(NSTableView *)aTableView { return NO; }
- (BOOL)dummy_tableView:(NSTableView *)tableView shouldSelectRow:(int)row { return NO; }
- (BOOL)dummy_tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn { return NO; }

- (void)dummy_tableView:(NSTableView*)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn {}
- (void)dummy_tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn {}
- (void)dummy_tableView:(NSTableView*)tableView didDragTableColumn:(NSTableColumn *)tableColumn {}

// @interface NSObject(NSTextDelegate)
- (BOOL)dummy_textShouldBeginEditing:(NSText *)textObject { return NO; }
- (BOOL)dummy_textShouldEndEditing:(NSText *)textObject { return NO; }
- (void)dummy_textDidBeginEditing:(NSNotification *)notification {}
- (void)dummy_textDidEndEditing:(NSNotification *)notification {}
- (void)dummy_textDidChange:(NSNotification *)notification {}

// @interface NSObject (NSTextStorageDelegate)
- (void)dummy_textStorageWillProcessEditing:(NSNotification *)notification {}
- (void)dummy_textStorageDidProcessEditing:(NSNotification *)notification {}

// @interface NSObject (NSTextViewDelegate)
- (BOOL)dummy_textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(unsigned)charIndex { return NO; }
- (void)dummy_textView:(NSTextView *)textView clickedOnCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)cellFrame atIndex:(unsigned)charIndex {}
- (void)dummy_textView:(NSTextView *)textView doubleClickedOnCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)cellFrame atIndex:(unsigned)charIndex {}
- (void)dummy_textView:(NSTextView *)view draggedCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)rect event:(NSEvent *)event atIndex:(unsigned)charIndex {}
- (NSArray *)dummy_textView:(NSTextView *)view writablePasteboardTypesForCell:(id <NSTextAttachmentCell>)cell atIndex:(unsigned)charIndex { return nil; }
- (BOOL)dummy_textView:(NSTextView *)view writeCell:(id <NSTextAttachmentCell>)cell atIndex:(unsigned)charIndex toPasteboard:(NSPasteboard *)pboard type:(NSString *)type { return NO; }
- (NSRange)dummy_textView:(NSTextView *)textView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange { NSRange r = {0,0}; return r; }
- (void)dummy_textViewDidChangeSelection:(NSNotification *)notification {}
- (BOOL)dummy_textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString { return NO; }
- (BOOL)dummy_textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector { return NO; }
- (BOOL)dummy_textView:(NSTextView *)textView clickedOnLink:(id)link { return NO; }
- (void)dummy_textView:(NSTextView *)textView clickedOnCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)cellFrame {}
- (void)dummy_textView:(NSTextView *)textView doubleClickedOnCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)cellFrame {}
- (void)dummy_textView:(NSTextView *)view draggedCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)rect event:(NSEvent *)event {}
- (NSUndoManager *)dummy_undoManagerForTextView:(NSTextView *)view { return nil; }

// @interface NSObject (NSToolbarDelegate)
- (NSToolbarItem *)dummy_toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag { return nil; }
- (NSArray *)dummy_toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar { return nil; }
- (NSArray *)dummy_toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar { return nil; }

// @interface NSObject(NSWindowDelegate)
- (BOOL)dummy_windowShouldClose:(id)sender { return NO; }
- (id)dummy_windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)client { return nil; }
- (NSSize)dummy_windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize { NSSize r = { 0.0,0.0}; return r; }
- (NSRect)dummy_windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame { NSRect r = {{0.0,0.0},{0.0,0.0}}; return r; }
- (BOOL)dummy_windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame { return NO; }
- (NSUndoManager *)dummy_windowWillReturnUndoManager:(NSWindow *)window { return nil; }


@end
