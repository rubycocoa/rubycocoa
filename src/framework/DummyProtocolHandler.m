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
#import "DummyProtocolHandler.h"
#import <Cocoa/Cocoa.h>

static DummyProtocolHandler* the_instance = nil;

@implementation DummyProtocolHandler

+ (void) initialize
{
  if (the_instance == nil) {
    the_instance = [[self alloc] init];
  }
}

+ instance
{
  if (the_instance == nil) {
    the_instance = [[self alloc] init];
  }
  return the_instance;
}

// other
- ruby_method_0 { return nil; }
- ruby_method_1:a1 { return nil; }
- ruby_method_2:a1,... { return nil; }

// as Observer
- (void)receiveNotification: (NSNotification *)notification {}

// @interface NSObject (NSNibAwaking)
- (void)awakeFromNib {}

// @interface NSApplication(NSWindowsMenu)
- (void)setWindowsMenu:(NSMenu *)aMenu {}
- (NSMenu *)windowsMenu { return nil; }
- (void)arrangeInFront:(id)sender {}
- (void)removeWindowsItem:(NSWindow *)win {}
- (void)addWindowsItem:(NSWindow *)win title:(NSString *)aString filename:(BOOL)isFilename {}
- (void)changeWindowsItem:(NSWindow *)win title:(NSString *)aString filename:(BOOL)isFilename {}
- (void)updateWindowsItem:(NSWindow *)win {}
- (void)miniaturizeAll:(id)sender {}

// @interface NSObject(NSApplicationNotifications)
- (void)applicationWillFinishLaunching:(NSNotification *)notification {}
- (void)applicationDidFinishLaunching:(NSNotification *)notification {}
- (void)applicationWillHide:(NSNotification *)notification {}
- (void)applicationDidHide:(NSNotification *)notification {}
- (void)applicationWillUnhide:(NSNotification *)notification {}
- (void)applicationDidUnhide:(NSNotification *)notification {}
- (void)applicationWillBecomeActive:(NSNotification *)notification {}
- (void)applicationDidBecomeActive:(NSNotification *)notification {}
- (void)applicationWillResignActive:(NSNotification *)notification {}
- (void)applicationDidResignActive:(NSNotification *)notification {}
- (void)applicationWillUpdate:(NSNotification *)notification {}
- (void)applicationDidUpdate:(NSNotification *)notification {}
- (void)applicationWillTerminate:(NSNotification *)notification {}
- (void)applicationDidChangeScreenParameters:(NSNotification *)notification {}

// @interface NSObject(NSApplicationDelegate)
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender { return 0; }
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename { return NO; }
- (BOOL)application:(NSApplication *)sender openTempFile:(NSString *)filename { return NO; }
- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender { return NO; }
- (BOOL)applicationOpenUntitledFile:(NSApplication *)sender { return NO; }
- (BOOL)application:(id)sender openFileWithoutUI:(NSString *)filename { return NO; }
- (BOOL)application:(NSApplication *)sender printFile:(NSString *)filename { return NO; }
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender { return NO; }
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag { return NO; }
- (NSMenu *)applicationDockMenu:(NSApplication *)sender { return nil; }

// @interface NSObject (NSConnectionDelegateMethods)
- (BOOL)makeNewConnection:(NSConnection *)conn sender:(NSConnection *)ancestor { return NO; }
- (BOOL)connection:(NSConnection *)ancestor shouldMakeNewConnection:(NSConnection *)conn { return NO; }
- (NSData *)authenticationDataForComponents:(NSArray *)components { return nil; }
- (BOOL)authenticateComponents:(NSArray *)components withData:(NSData *)signature { return NO; }
- (id)createConversationForConnection:(NSConnection *)conn { return nil; }

// @interface NSObject (NSPortDelegateMethods)
- (void)handlePortMessage:(NSPortMessage *)message {}

// @interface NSObject (NSMachPortDelegateMethods)
- (void)handleMachMessage:(void *)msg {}

// @interface NSObject(NSSpellServerDelegate)
- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language wordCount:(int *)wordCount countOnly:(BOOL)countOnly { NSRange dummy = {0,0}; return dummy; }
- (NSArray *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word inLanguage:(NSString *)language { return nil; }
- (void)spellServer:(NSSpellServer *)sender didLearnWord:(NSString *)word inLanguage:(NSString *)language {}
- (void)spellServer:(NSSpellServer *)sender didForgetWord:(NSString *)word inLanguage:(NSString *)language {}

// @interface NSObject(NSBrowserDelegate)
- (int)browser:(NSBrowser *)sender numberOfRowsInColumn:(int)column { return 0; }
- (void)browser:(NSBrowser *)sender createRowsForColumn:(int)column inMatrix:(NSMatrix *)matrix {}
- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell atRow:(int)row column:(int)column {}
- (NSString *)browser:(NSBrowser *)sender titleOfColumn:(int)column { return nil; }
- (BOOL)browser:(NSBrowser *)sender selectCellWithString:(NSString *)title inColumn:(int)column { return NO; }
- (BOOL)browser:(NSBrowser *)sender selectRow:(int)row inColumn:(int)column { return NO; }
- (BOOL)browser:(NSBrowser *)sender isColumnValid:(int)column { return NO; }
- (void)browserWillScroll:(NSBrowser *)sender {}
- (void)browserDidScroll:(NSBrowser *)sender {}

// @interface NSObject(NSControlSubclassDelegate)
- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor { return NO; }
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor { return NO; }
- (BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error { return NO; }
- (void)control:(NSControl *)control didFailToValidatePartialString:(NSString *)string errorDescription:(NSString *)error {}
- (BOOL)control:(NSControl *)control isValidObject:(id)obj { return NO; }

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector { return NO; }

// @interface NSObject(NSDrawerDelegate)
- (BOOL)drawerShouldOpen:(NSDrawer *)sender { return NO; }
- (BOOL)drawerShouldClose:(NSDrawer *)sender { return NO; }
- (NSSize)drawerWillResizeContents:(NSDrawer *)sender toSize:(NSSize)contentSize { NSSize s = {0.0,0.0}; return s; }

// @interface NSObject(NSFontManagerDelegate)
- (BOOL)fontManager:(id)sender willIncludeFont:(NSString *)fontName { return NO; }

// @interface NSObject(NSImageDelegate)
- (NSImage *)imageDidNotDraw:(id)sender inRect:(NSRect)aRect { return nil; }

// @interface NSObject (NSLayoutManagerDelegate)
- (void)layoutManagerDidInvalidateLayout:(NSLayoutManager *)sender {}
- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {}

// @interface NSObject(NSOutlineViewDelegate)
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item { return NO; }
- (BOOL)selectionShouldChangeInOutlineView:(NSOutlineView *)outlineView { return NO; }
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item { return NO; }
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectTableColumn:(NSTableColumn *)tableColumn { return NO; }
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item { return NO; }
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item { return NO; }
- (void)outlineView:(NSOutlineView *)outlineView willDisplayOutlineCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {}

// @interface NSObject(NSSavePanelDelegate)
- (NSString *)panel:(id)sender userEnteredFilename:(NSString *)filename confirmed:(BOOL)okFlag { return nil; }
- (BOOL)panel:(id)sender isValidFilename:(NSString *)filename { return NO; }
- (BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename { return NO; }
- (NSComparisonResult)panel:(id)sender compareFilename:(NSString *)file1 with:(NSString *)file2 caseSensitive:(BOOL)caseSensitive { return NSOrderedSame; }
- (void)panel:(id)sender willExpand:(BOOL)expanding {}

// @interface NSObject (NSSoundDelegateMethods)
- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)aBool {}

// @interface NSObject(NSSplitViewDelegate)
- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize {}
- (float)splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedCoord ofSubviewAt:(int)offset { return 0.0; }
- (float)splitView:(NSSplitView *)sender constrainMaxCoordinate:(float)proposedCoord ofSubviewAt:(int)offset { return 0.0; }
- (void)splitViewWillResizeSubviews:(NSNotification *)notification {}
- (void)splitViewDidResizeSubviews:(NSNotification *)notification {}
- (BOOL)splitView:(NSSplitView *)sender canCollapseSubview:(NSView *)subview { return NO; }
- (float)splitView:(NSSplitView *)splitView constrainSplitPosition:(float)proposedPosition ofSubviewAt:(int)index { return 0.0; }

// @interface NSObject(NSTabViewDelegate)
- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem { return NO; }
- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem {}
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {}
- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)TabView {}

// @interface NSObject(NSTableViewDelegate)
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row {}
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(int)row { return NO; }
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView { return NO; }
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row { return NO; }
- (BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn { return NO; }

- (void)tableView:(NSTableView*)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn {}
- (void)tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn {}
- (void)tableView:(NSTableView*)tableView didDragTableColumn:(NSTableColumn *)tableColumn {}

// @interface NSObject(NSTextDelegate)
- (BOOL)textShouldBeginEditing:(NSText *)textObject { return NO; }
- (BOOL)textShouldEndEditing:(NSText *)textObject { return NO; }
- (void)textDidBeginEditing:(NSNotification *)notification {}
- (void)textDidEndEditing:(NSNotification *)notification {}
- (void)textDidChange:(NSNotification *)notification {}

// @interface NSObject (NSTextStorageDelegate)
- (void)textStorageWillProcessEditing:(NSNotification *)notification {}
- (void)textStorageDidProcessEditing:(NSNotification *)notification {}

// @interface NSObject (NSTextViewDelegate)
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(unsigned)charIndex { return NO; }
- (void)textView:(NSTextView *)textView clickedOnCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)cellFrame atIndex:(unsigned)charIndex {}
- (void)textView:(NSTextView *)textView doubleClickedOnCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)cellFrame atIndex:(unsigned)charIndex {}
- (void)textView:(NSTextView *)view draggedCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)rect event:(NSEvent *)event atIndex:(unsigned)charIndex {}
- (NSArray *)textView:(NSTextView *)view writablePasteboardTypesForCell:(id <NSTextAttachmentCell>)cell atIndex:(unsigned)charIndex { return nil; }
- (BOOL)textView:(NSTextView *)view writeCell:(id <NSTextAttachmentCell>)cell atIndex:(unsigned)charIndex toPasteboard:(NSPasteboard *)pboard type:(NSString *)type { return NO; }
- (NSRange)textView:(NSTextView *)textView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange { NSRange r = {0,0}; return r; }
- (void)textViewDidChangeSelection:(NSNotification *)notification {}
- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString { return NO; }
- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector { return NO; }
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link { return NO; }
- (void)textView:(NSTextView *)textView clickedOnCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)cellFrame {}
- (void)textView:(NSTextView *)textView doubleClickedOnCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)cellFrame {}
- (void)textView:(NSTextView *)view draggedCell:(id <NSTextAttachmentCell>)cell inRect:(NSRect)rect event:(NSEvent *)event {}
- (NSUndoManager *)undoManagerForTextView:(NSTextView *)view { return nil; }

// @interface NSObject (NSToolbarDelegate)
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag { return nil; }
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar { return nil; }
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar { return nil; }

// @interface NSObject(NSWindowNotifications)
- (void)windowDidResize:(NSNotification *)notification {}
- (void)windowDidExpose:(NSNotification *)notification {}
- (void)windowWillMove:(NSNotification *)notification {}
- (void)windowDidMove:(NSNotification *)notification {}
- (void)windowDidBecomeKey:(NSNotification *)notification {}
- (void)windowDidResignKey:(NSNotification *)notification {}
- (void)windowDidBecomeMain:(NSNotification *)notification {}
- (void)windowDidResignMain:(NSNotification *)notification {}
- (void)windowWillClose:(NSNotification *)notification {}
- (void)windowWillMiniaturize:(NSNotification *)notification {}
- (void)windowDidMiniaturize:(NSNotification *)notification {}
- (void)windowDidDeminiaturize:(NSNotification *)notification {}
- (void)windowDidUpdate:(NSNotification *)notification {}
- (void)windowDidChangeScreen:(NSNotification *)notification {}
- (void)windowWillBeginSheet:(NSNotification *)notification {}
- (void)windowDidEndSheet:(NSNotification *)notification {}

// @interface NSObject(NSWindowDelegate)
- (BOOL)windowShouldClose:(id)sender { return NO; }
- (id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)client { return nil; }
- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize { NSSize r = { 0.0,0.0}; return r; }
- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame { NSRect r = {{0.0,0.0},{0.0,0.0}}; return r; }
- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame { return NO; }
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window { return nil; }


@end
