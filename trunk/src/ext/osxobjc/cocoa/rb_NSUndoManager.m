#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSUndoManagerCheckpointNotification;
static VALUE
osx_NSUndoManagerCheckpointNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSUndoManagerWillUndoChangeNotification;
static VALUE
osx_NSUndoManagerWillUndoChangeNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSUndoManagerWillRedoChangeNotification;
static VALUE
osx_NSUndoManagerWillRedoChangeNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSUndoManagerDidUndoChangeNotification;
static VALUE
osx_NSUndoManagerDidUndoChangeNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSUndoManagerDidRedoChangeNotification;
static VALUE
osx_NSUndoManagerDidRedoChangeNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSUndoManagerDidOpenUndoGroupNotification;
static VALUE
osx_NSUndoManagerDidOpenUndoGroupNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSUndoManagerWillCloseUndoGroupNotification;
static VALUE
osx_NSUndoManagerWillCloseUndoGroupNotification(VALUE mdl)
{
  rb_notimplement();
}

void init_NSUndoManager(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSUndoCloseGroupingRunLoopOrdering", INT2NUM(NSUndoCloseGroupingRunLoopOrdering));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSUndoManagerCheckpointNotification", osx_NSUndoManagerCheckpointNotification, 0);
  rb_define_module_function(mOSX, "NSUndoManagerWillUndoChangeNotification", osx_NSUndoManagerWillUndoChangeNotification, 0);
  rb_define_module_function(mOSX, "NSUndoManagerWillRedoChangeNotification", osx_NSUndoManagerWillRedoChangeNotification, 0);
  rb_define_module_function(mOSX, "NSUndoManagerDidUndoChangeNotification", osx_NSUndoManagerDidUndoChangeNotification, 0);
  rb_define_module_function(mOSX, "NSUndoManagerDidRedoChangeNotification", osx_NSUndoManagerDidRedoChangeNotification, 0);
  rb_define_module_function(mOSX, "NSUndoManagerDidOpenUndoGroupNotification", osx_NSUndoManagerDidOpenUndoGroupNotification, 0);
  rb_define_module_function(mOSX, "NSUndoManagerWillCloseUndoGroupNotification", osx_NSUndoManagerWillCloseUndoGroupNotification, 0);
}
