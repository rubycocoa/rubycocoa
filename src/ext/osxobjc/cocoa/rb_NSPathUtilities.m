#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** functions ****/
// NSString *NSUserName(void);
static VALUE
osx_NSUserName(VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
  
  ns_result =  NSUserName();
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSString *NSFullUserName(void);
static VALUE
osx_NSFullUserName(VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
  
  ns_result =  NSFullUserName();
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSString *NSHomeDirectory(void);
static VALUE
osx_NSHomeDirectory(VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
  
  ns_result =  NSHomeDirectory();
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSString *NSHomeDirectoryForUser(NSString *userName);
static VALUE
osx_NSHomeDirectoryForUser(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSHomeDirectoryForUser(oc_args[0]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSString *NSTemporaryDirectory(void);
static VALUE
osx_NSTemporaryDirectory(VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
  
  ns_result =  NSTemporaryDirectory();
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSString *NSOpenStepRootDirectory(void);
static VALUE
osx_NSOpenStepRootDirectory(VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
  
  ns_result =  NSOpenStepRootDirectory();
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSArray *NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde);
static VALUE
osx_NSSearchPathForDirectoriesInDomains(int argc, VALUE* argv, VALUE mdl)
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
  rb_define_module_function(mOSX, "NSHomeDirectoryForUser", osx_NSHomeDirectoryForUser, -1);
  rb_define_module_function(mOSX, "NSTemporaryDirectory", osx_NSTemporaryDirectory, 0);
  rb_define_module_function(mOSX, "NSOpenStepRootDirectory", osx_NSOpenStepRootDirectory, 0);
  rb_define_module_function(mOSX, "NSSearchPathForDirectoriesInDomains", osx_NSSearchPathForDirectoriesInDomains, -1);
}
