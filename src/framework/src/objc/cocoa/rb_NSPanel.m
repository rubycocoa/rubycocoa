#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// int NSRunAlertPanel ( NSString * title , NSString * msg , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , ... );
static VALUE
osx_NSRunAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  int ns_result;

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSString * ns_a4;
  int va_first = 5;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSRunAlertPanel", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSRunAlertPanel", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSRunAlertPanel", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSRunAlertPanel", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSRunAlertPanel", pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSRunAlertPanel", pool, i);

NS_DURING
  if (argc == va_first)
    ns_result = NSRunAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);
  else if (argc == (va_first + 1))
    ns_result = NSRunAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0]);
  else if (argc == (va_first + 2))
    ns_result = NSRunAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    ns_result = NSRunAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    ns_result = NSRunAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSRunAlertPanel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSRunAlertPanel", pool);
  [pool release];
  return rb_result;
}

// int NSRunInformationalAlertPanel ( NSString * title , NSString * msg , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , ... );
static VALUE
osx_NSRunInformationalAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  int ns_result;

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSString * ns_a4;
  int va_first = 5;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSRunInformationalAlertPanel", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSRunInformationalAlertPanel", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSRunInformationalAlertPanel", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSRunInformationalAlertPanel", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSRunInformationalAlertPanel", pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSRunInformationalAlertPanel", pool, i);

NS_DURING
  if (argc == va_first)
    ns_result = NSRunInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);
  else if (argc == (va_first + 1))
    ns_result = NSRunInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0]);
  else if (argc == (va_first + 2))
    ns_result = NSRunInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    ns_result = NSRunInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    ns_result = NSRunInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSRunInformationalAlertPanel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSRunInformationalAlertPanel", pool);
  [pool release];
  return rb_result;
}

// int NSRunCriticalAlertPanel ( NSString * title , NSString * msg , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , ... );
static VALUE
osx_NSRunCriticalAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  int ns_result;

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSString * ns_a4;
  int va_first = 5;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSRunCriticalAlertPanel", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSRunCriticalAlertPanel", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSRunCriticalAlertPanel", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSRunCriticalAlertPanel", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSRunCriticalAlertPanel", pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSRunCriticalAlertPanel", pool, i);

NS_DURING
  if (argc == va_first)
    ns_result = NSRunCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);
  else if (argc == (va_first + 1))
    ns_result = NSRunCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0]);
  else if (argc == (va_first + 2))
    ns_result = NSRunCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    ns_result = NSRunCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    ns_result = NSRunCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSRunCriticalAlertPanel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSRunCriticalAlertPanel", pool);
  [pool release];
  return rb_result;
}

// int NSRunAlertPanelRelativeToWindow ( NSString * title , NSString * msg , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , NSWindow * docWindow , ... );
static VALUE
osx_NSRunAlertPanelRelativeToWindow(int argc, VALUE* argv, VALUE mdl)
{
  int ns_result;

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSString * ns_a4;
  NSWindow * ns_a5;
  int va_first = 6;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSRunAlertPanelRelativeToWindow", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSRunAlertPanelRelativeToWindow", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSRunAlertPanelRelativeToWindow", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSRunAlertPanelRelativeToWindow", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSRunAlertPanelRelativeToWindow", pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, "NSRunAlertPanelRelativeToWindow", pool, 5);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSRunAlertPanelRelativeToWindow", pool, i);

NS_DURING
  if (argc == va_first)
    ns_result = NSRunAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5);
  else if (argc == (va_first + 1))
    ns_result = NSRunAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0]);
  else if (argc == (va_first + 2))
    ns_result = NSRunAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    ns_result = NSRunAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    ns_result = NSRunAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSRunAlertPanelRelativeToWindow", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSRunAlertPanelRelativeToWindow", pool);
  [pool release];
  return rb_result;
}

// int NSRunInformationalAlertPanelRelativeToWindow ( NSString * title , NSString * msg , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , NSWindow * docWindow , ... );
static VALUE
osx_NSRunInformationalAlertPanelRelativeToWindow(int argc, VALUE* argv, VALUE mdl)
{
  int ns_result;

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSString * ns_a4;
  NSWindow * ns_a5;
  int va_first = 6;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSRunInformationalAlertPanelRelativeToWindow", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSRunInformationalAlertPanelRelativeToWindow", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSRunInformationalAlertPanelRelativeToWindow", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSRunInformationalAlertPanelRelativeToWindow", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSRunInformationalAlertPanelRelativeToWindow", pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, "NSRunInformationalAlertPanelRelativeToWindow", pool, 5);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSRunInformationalAlertPanelRelativeToWindow", pool, i);

NS_DURING
  if (argc == va_first)
    ns_result = NSRunInformationalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5);
  else if (argc == (va_first + 1))
    ns_result = NSRunInformationalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0]);
  else if (argc == (va_first + 2))
    ns_result = NSRunInformationalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    ns_result = NSRunInformationalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    ns_result = NSRunInformationalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSRunInformationalAlertPanelRelativeToWindow", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSRunInformationalAlertPanelRelativeToWindow", pool);
  [pool release];
  return rb_result;
}

// int NSRunCriticalAlertPanelRelativeToWindow ( NSString * title , NSString * msg , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , NSWindow * docWindow , ... );
static VALUE
osx_NSRunCriticalAlertPanelRelativeToWindow(int argc, VALUE* argv, VALUE mdl)
{
  int ns_result;

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSString * ns_a4;
  NSWindow * ns_a5;
  int va_first = 6;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSRunCriticalAlertPanelRelativeToWindow", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSRunCriticalAlertPanelRelativeToWindow", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSRunCriticalAlertPanelRelativeToWindow", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSRunCriticalAlertPanelRelativeToWindow", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSRunCriticalAlertPanelRelativeToWindow", pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, "NSRunCriticalAlertPanelRelativeToWindow", pool, 5);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSRunCriticalAlertPanelRelativeToWindow", pool, i);

NS_DURING
  if (argc == va_first)
    ns_result = NSRunCriticalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5);
  else if (argc == (va_first + 1))
    ns_result = NSRunCriticalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0]);
  else if (argc == (va_first + 2))
    ns_result = NSRunCriticalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    ns_result = NSRunCriticalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    ns_result = NSRunCriticalAlertPanelRelativeToWindow(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSRunCriticalAlertPanelRelativeToWindow", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSRunCriticalAlertPanelRelativeToWindow", pool);
  [pool release];
  return rb_result;
}

// void NSBeginAlertSheet ( NSString * title , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , NSWindow * docWindow , id modalDelegate , SEL didEndSelector , SEL didDismissSelector , void * contextInfo , NSString * msg , ... );
static VALUE
osx_NSBeginAlertSheet(int argc, VALUE* argv, VALUE mdl)
{

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSWindow * ns_a4;
  id ns_a5;
  SEL ns_a6;
  SEL ns_a7;
  void * ns_a8;
  NSString * ns_a9;
  int va_first = 10;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSBeginAlertSheet", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSBeginAlertSheet", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSBeginAlertSheet", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSBeginAlertSheet", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSBeginAlertSheet", pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, "NSBeginAlertSheet", pool, 5);
  /* argv[6] */
  rbarg_to_nsarg(argv[6], _C_SEL, &ns_a6, "NSBeginAlertSheet", pool, 6);
  /* argv[7] */
  rbarg_to_nsarg(argv[7], _C_SEL, &ns_a7, "NSBeginAlertSheet", pool, 7);
  /* argv[8] */
  rbarg_to_nsarg(argv[8], _PRIV_C_PTR, &ns_a8, "NSBeginAlertSheet", pool, 8);
  /* argv[9] */
  rbarg_to_nsarg(argv[9], _C_ID, &ns_a9, "NSBeginAlertSheet", pool, 9);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSBeginAlertSheet", pool, i);

NS_DURING
  if (argc == va_first)
    NSBeginAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9);
  else if (argc == (va_first + 1))
    NSBeginAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0]);
  else if (argc == (va_first + 2))
    NSBeginAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    NSBeginAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    NSBeginAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSBeginAlertSheet", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSBeginInformationalAlertSheet ( NSString * title , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , NSWindow * docWindow , id modalDelegate , SEL didEndSelector , SEL didDismissSelector , void * contextInfo , NSString * msg , ... );
static VALUE
osx_NSBeginInformationalAlertSheet(int argc, VALUE* argv, VALUE mdl)
{

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSWindow * ns_a4;
  id ns_a5;
  SEL ns_a6;
  SEL ns_a7;
  void * ns_a8;
  NSString * ns_a9;
  int va_first = 10;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSBeginInformationalAlertSheet", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSBeginInformationalAlertSheet", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSBeginInformationalAlertSheet", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSBeginInformationalAlertSheet", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSBeginInformationalAlertSheet", pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, "NSBeginInformationalAlertSheet", pool, 5);
  /* argv[6] */
  rbarg_to_nsarg(argv[6], _C_SEL, &ns_a6, "NSBeginInformationalAlertSheet", pool, 6);
  /* argv[7] */
  rbarg_to_nsarg(argv[7], _C_SEL, &ns_a7, "NSBeginInformationalAlertSheet", pool, 7);
  /* argv[8] */
  rbarg_to_nsarg(argv[8], _PRIV_C_PTR, &ns_a8, "NSBeginInformationalAlertSheet", pool, 8);
  /* argv[9] */
  rbarg_to_nsarg(argv[9], _C_ID, &ns_a9, "NSBeginInformationalAlertSheet", pool, 9);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSBeginInformationalAlertSheet", pool, i);

NS_DURING
  if (argc == va_first)
    NSBeginInformationalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9);
  else if (argc == (va_first + 1))
    NSBeginInformationalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0]);
  else if (argc == (va_first + 2))
    NSBeginInformationalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    NSBeginInformationalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    NSBeginInformationalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSBeginInformationalAlertSheet", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSBeginCriticalAlertSheet ( NSString * title , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , NSWindow * docWindow , id modalDelegate , SEL didEndSelector , SEL didDismissSelector , void * contextInfo , NSString * msg , ... );
static VALUE
osx_NSBeginCriticalAlertSheet(int argc, VALUE* argv, VALUE mdl)
{

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSWindow * ns_a4;
  id ns_a5;
  SEL ns_a6;
  SEL ns_a7;
  void * ns_a8;
  NSString * ns_a9;
  int va_first = 10;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSBeginCriticalAlertSheet", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSBeginCriticalAlertSheet", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSBeginCriticalAlertSheet", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSBeginCriticalAlertSheet", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSBeginCriticalAlertSheet", pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, "NSBeginCriticalAlertSheet", pool, 5);
  /* argv[6] */
  rbarg_to_nsarg(argv[6], _C_SEL, &ns_a6, "NSBeginCriticalAlertSheet", pool, 6);
  /* argv[7] */
  rbarg_to_nsarg(argv[7], _C_SEL, &ns_a7, "NSBeginCriticalAlertSheet", pool, 7);
  /* argv[8] */
  rbarg_to_nsarg(argv[8], _PRIV_C_PTR, &ns_a8, "NSBeginCriticalAlertSheet", pool, 8);
  /* argv[9] */
  rbarg_to_nsarg(argv[9], _C_ID, &ns_a9, "NSBeginCriticalAlertSheet", pool, 9);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSBeginCriticalAlertSheet", pool, i);

NS_DURING
  if (argc == va_first)
    NSBeginCriticalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9);
  else if (argc == (va_first + 1))
    NSBeginCriticalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0]);
  else if (argc == (va_first + 2))
    NSBeginCriticalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    NSBeginCriticalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    NSBeginCriticalAlertSheet(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSBeginCriticalAlertSheet", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// id NSGetAlertPanel ( NSString * title , NSString * msg , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , ... );
static VALUE
osx_NSGetAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  id ns_result;

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSString * ns_a4;
  int va_first = 5;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSGetAlertPanel", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSGetAlertPanel", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSGetAlertPanel", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSGetAlertPanel", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSGetAlertPanel", pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSGetAlertPanel", pool, i);

NS_DURING
  if (argc == va_first)
    ns_result = NSGetAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);
  else if (argc == (va_first + 1))
    ns_result = NSGetAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0]);
  else if (argc == (va_first + 2))
    ns_result = NSGetAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    ns_result = NSGetAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    ns_result = NSGetAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSGetAlertPanel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSGetAlertPanel", pool);
  [pool release];
  return rb_result;
}

// id NSGetInformationalAlertPanel ( NSString * title , NSString * msg , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , ... );
static VALUE
osx_NSGetInformationalAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  id ns_result;

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSString * ns_a4;
  int va_first = 5;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSGetInformationalAlertPanel", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSGetInformationalAlertPanel", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSGetInformationalAlertPanel", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSGetInformationalAlertPanel", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSGetInformationalAlertPanel", pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSGetInformationalAlertPanel", pool, i);

NS_DURING
  if (argc == va_first)
    ns_result = NSGetInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);
  else if (argc == (va_first + 1))
    ns_result = NSGetInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0]);
  else if (argc == (va_first + 2))
    ns_result = NSGetInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    ns_result = NSGetInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    ns_result = NSGetInformationalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSGetInformationalAlertPanel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSGetInformationalAlertPanel", pool);
  [pool release];
  return rb_result;
}

// id NSGetCriticalAlertPanel ( NSString * title , NSString * msg , NSString * defaultButton , NSString * alternateButton , NSString * otherButton , ... );
static VALUE
osx_NSGetCriticalAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  id ns_result;

  NSString * ns_a0;
  NSString * ns_a1;
  NSString * ns_a2;
  NSString * ns_a3;
  NSString * ns_a4;
  int va_first = 5;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSGetCriticalAlertPanel", pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, "NSGetCriticalAlertPanel", pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, "NSGetCriticalAlertPanel", pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, "NSGetCriticalAlertPanel", pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, "NSGetCriticalAlertPanel", pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSGetCriticalAlertPanel", pool, i);

NS_DURING
  if (argc == va_first)
    ns_result = NSGetCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);
  else if (argc == (va_first + 1))
    ns_result = NSGetCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0]);
  else if (argc == (va_first + 2))
    ns_result = NSGetCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    ns_result = NSGetCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    ns_result = NSGetCriticalAlertPanel(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSGetCriticalAlertPanel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSGetCriticalAlertPanel", pool);
  [pool release];
  return rb_result;
}

// void NSReleaseAlertPanel ( id panel );
static VALUE
osx_NSReleaseAlertPanel(VALUE mdl, VALUE a0)
{

  id ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSReleaseAlertPanel", pool, 0);

NS_DURING
  NSReleaseAlertPanel(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSReleaseAlertPanel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

void init_NSPanel(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSAlertDefaultReturn", INT2NUM(NSAlertDefaultReturn));
  rb_define_const(mOSX, "NSAlertAlternateReturn", INT2NUM(NSAlertAlternateReturn));
  rb_define_const(mOSX, "NSAlertOtherReturn", INT2NUM(NSAlertOtherReturn));
  rb_define_const(mOSX, "NSAlertErrorReturn", INT2NUM(NSAlertErrorReturn));
  rb_define_const(mOSX, "NSOKButton", INT2NUM(NSOKButton));
  rb_define_const(mOSX, "NSCancelButton", INT2NUM(NSCancelButton));
  rb_define_const(mOSX, "NSUtilityWindowMask", INT2NUM(NSUtilityWindowMask));
  rb_define_const(mOSX, "NSDocModalWindowMask", INT2NUM(NSDocModalWindowMask));
  rb_define_const(mOSX, "NSNonactivatingPanelMask", INT2NUM(NSNonactivatingPanelMask));

  /**** functions ****/
  rb_define_module_function(mOSX, "NSRunAlertPanel", osx_NSRunAlertPanel, -1);
  rb_define_module_function(mOSX, "NSRunInformationalAlertPanel", osx_NSRunInformationalAlertPanel, -1);
  rb_define_module_function(mOSX, "NSRunCriticalAlertPanel", osx_NSRunCriticalAlertPanel, -1);
  rb_define_module_function(mOSX, "NSRunAlertPanelRelativeToWindow", osx_NSRunAlertPanelRelativeToWindow, -1);
  rb_define_module_function(mOSX, "NSRunInformationalAlertPanelRelativeToWindow", osx_NSRunInformationalAlertPanelRelativeToWindow, -1);
  rb_define_module_function(mOSX, "NSRunCriticalAlertPanelRelativeToWindow", osx_NSRunCriticalAlertPanelRelativeToWindow, -1);
  rb_define_module_function(mOSX, "NSBeginAlertSheet", osx_NSBeginAlertSheet, -1);
  rb_define_module_function(mOSX, "NSBeginInformationalAlertSheet", osx_NSBeginInformationalAlertSheet, -1);
  rb_define_module_function(mOSX, "NSBeginCriticalAlertSheet", osx_NSBeginCriticalAlertSheet, -1);
  rb_define_module_function(mOSX, "NSGetAlertPanel", osx_NSGetAlertPanel, -1);
  rb_define_module_function(mOSX, "NSGetInformationalAlertPanel", osx_NSGetInformationalAlertPanel, -1);
  rb_define_module_function(mOSX, "NSGetCriticalAlertPanel", osx_NSGetCriticalAlertPanel, -1);
  rb_define_module_function(mOSX, "NSReleaseAlertPanel", osx_NSReleaseAlertPanel, 1);
}
