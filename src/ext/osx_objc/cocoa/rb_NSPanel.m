#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


  /**** functions ****/
// int NSRunAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// int NSRunInformationalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// int NSRunCriticalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// int NSRunAlertPanelRelativeToWindow(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, pool, 5);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// int NSRunInformationalAlertPanelRelativeToWindow(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, pool, 5);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// int NSRunCriticalAlertPanelRelativeToWindow(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, pool, 5);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSBeginAlertSheet(NSString *title, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, id modalDelegate, SEL didEndSelector, SEL didDismissSelector, void *contextInfo, NSString *msg, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, pool, 5);
  /* argv[6] */
  rbarg_to_nsarg(argv[6], _C_SEL, &ns_a6, pool, 6);
  /* argv[7] */
  rbarg_to_nsarg(argv[7], _C_SEL, &ns_a7, pool, 7);
  /* argv[8] */
  rbarg_to_nsarg(argv[8], _C_PTR, &ns_a8, pool, 8);
  /* argv[9] */
  rbarg_to_nsarg(argv[9], _C_ID, &ns_a9, pool, 9);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSBeginInformationalAlertSheet(NSString *title, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, id modalDelegate, SEL didEndSelector, SEL didDismissSelector, void *contextInfo, NSString *msg, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, pool, 5);
  /* argv[6] */
  rbarg_to_nsarg(argv[6], _C_SEL, &ns_a6, pool, 6);
  /* argv[7] */
  rbarg_to_nsarg(argv[7], _C_SEL, &ns_a7, pool, 7);
  /* argv[8] */
  rbarg_to_nsarg(argv[8], _C_PTR, &ns_a8, pool, 8);
  /* argv[9] */
  rbarg_to_nsarg(argv[9], _C_ID, &ns_a9, pool, 9);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSBeginCriticalAlertSheet(NSString *title, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, id modalDelegate, SEL didEndSelector, SEL didDismissSelector, void *contextInfo, NSString *msg, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* argv[5] */
  rbarg_to_nsarg(argv[5], _C_ID, &ns_a5, pool, 5);
  /* argv[6] */
  rbarg_to_nsarg(argv[6], _C_SEL, &ns_a6, pool, 6);
  /* argv[7] */
  rbarg_to_nsarg(argv[7], _C_SEL, &ns_a7, pool, 7);
  /* argv[8] */
  rbarg_to_nsarg(argv[8], _C_PTR, &ns_a8, pool, 8);
  /* argv[9] */
  rbarg_to_nsarg(argv[9], _C_ID, &ns_a9, pool, 9);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// id NSGetAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// id NSGetInformationalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// id NSGetCriticalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, pool, 0);
  /* argv[1] */
  rbarg_to_nsarg(argv[1], _C_ID, &ns_a1, pool, 1);
  /* argv[2] */
  rbarg_to_nsarg(argv[2], _C_ID, &ns_a2, pool, 2);
  /* argv[3] */
  rbarg_to_nsarg(argv[3], _C_ID, &ns_a3, pool, 3);
  /* argv[4] */
  rbarg_to_nsarg(argv[4], _C_ID, &ns_a4, pool, 4);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], pool, i);

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

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSReleaseAlertPanel(id panel);
static VALUE
osx_NSReleaseAlertPanel(VALUE mdl, VALUE a0)
{

  id ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  NSReleaseAlertPanel(ns_a0);

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
