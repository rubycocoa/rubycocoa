#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// NSString *NSUserName(void);
static VALUE
osx_NSUserName(VALUE mdl)
{
  NSString * ns_result = NSUserName();
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSFullUserName(void);
static VALUE
osx_NSFullUserName(VALUE mdl)
{
  NSString * ns_result = NSFullUserName();
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSHomeDirectory(void);
static VALUE
osx_NSHomeDirectory(VALUE mdl)
{
  NSString * ns_result = NSHomeDirectory();
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSHomeDirectoryForUser(NSString *userName);
static VALUE
osx_NSHomeDirectoryForUser(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSHomeDirectoryForUser(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSString *NSTemporaryDirectory(void);
static VALUE
osx_NSTemporaryDirectory(VALUE mdl)
{
  NSString * ns_result = NSTemporaryDirectory();
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSOpenStepRootDirectory(void);
static VALUE
osx_NSOpenStepRootDirectory(VALUE mdl)
{
  NSString * ns_result = NSOpenStepRootDirectory();
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSArray *NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde);
static VALUE
osx_NSSearchPathForDirectoriesInDomains(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

void init_NSPathUtilities(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSApplicationDirectory", INT2NUM(NSApplicationDirectory));
  rb_define_const(mOSX, "NSDemoApplicationDirectory", INT2NUM(NSDemoApplicationDirectory));
  rb_define_const(mOSX, "NSDeveloperApplicationDirectory", INT2NUM(NSDeveloperApplicationDirectory));
  rb_define_const(mOSX, "NSAdminApplicationDirectory", INT2NUM(NSAdminApplicationDirectory));
  rb_define_const(mOSX, "NSLibraryDirectory", INT2NUM(NSLibraryDirectory));
  rb_define_const(mOSX, "NSDeveloperDirectory", INT2NUM(NSDeveloperDirectory));
  rb_define_const(mOSX, "NSUserDirectory", INT2NUM(NSUserDirectory));
  rb_define_const(mOSX, "NSDocumentationDirectory", INT2NUM(NSDocumentationDirectory));
  rb_define_const(mOSX, "NSDocumentDirectory", INT2NUM(NSDocumentDirectory));
  rb_define_const(mOSX, "NSAllApplicationsDirectory", INT2NUM(NSAllApplicationsDirectory));
  rb_define_const(mOSX, "NSAllLibrariesDirectory", INT2NUM(NSAllLibrariesDirectory));
  rb_define_const(mOSX, "NSUserDomainMask", INT2NUM(NSUserDomainMask));
  rb_define_const(mOSX, "NSLocalDomainMask", INT2NUM(NSLocalDomainMask));
  rb_define_const(mOSX, "NSNetworkDomainMask", INT2NUM(NSNetworkDomainMask));
  rb_define_const(mOSX, "NSSystemDomainMask", INT2NUM(NSSystemDomainMask));
  rb_define_const(mOSX, "NSAllDomainsMask", INT2NUM(NSAllDomainsMask));

  /**** functions ****/
  rb_define_module_function(mOSX, "NSUserName", osx_NSUserName, 0);
  rb_define_module_function(mOSX, "NSFullUserName", osx_NSFullUserName, 0);
  rb_define_module_function(mOSX, "NSHomeDirectory", osx_NSHomeDirectory, 0);
  rb_define_module_function(mOSX, "NSHomeDirectoryForUser", osx_NSHomeDirectoryForUser, 1);
  rb_define_module_function(mOSX, "NSTemporaryDirectory", osx_NSTemporaryDirectory, 0);
  rb_define_module_function(mOSX, "NSOpenStepRootDirectory", osx_NSOpenStepRootDirectory, 0);
  rb_define_module_function(mOSX, "NSSearchPathForDirectoriesInDomains", osx_NSSearchPathForDirectoriesInDomains, 3);
}
