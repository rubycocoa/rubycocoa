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

#import <LibRuby/ruby.h>
#import <string.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSDictionary.h>
#import <RubyCocoa/RBObject.h>

#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

#import "OverrideMixin.h"
#import "ocdata_conv.h"

#define RUBY_MAIN_NAME "rb_main.rb"

static char* rb_main_path(const char* rb_main_name)
{
  char* result;
  id path;
  id pool = [[NSAutoreleasePool alloc] init];
  NSBundle* bundle = [NSBundle mainBundle];
  if (rb_main_name == NULL) rb_main_name = RUBY_MAIN_NAME;
  path = [NSString stringWithCString: rb_main_name];
  result = strdup([[bundle pathForResource: path ofType: nil] cString]);
  [pool release];
  return result;
}

static char* resource_path()
{
  NSString* str;
  char* result;
  id pool = [[NSAutoreleasePool alloc] init];
  NSBundle* bundle = [NSBundle mainBundle];
  str = [bundle resourcePath];
  result = strdup([str cString]);
  [pool release];
  return result;
}

static char* osxobjc_resource_path()
{
  NSString* str;
  char* result;
  id pool = [[NSAutoreleasePool alloc] init];
  NSBundle* bundle = [NSBundle bundleForClass: [RBObject class]];
  str = [bundle resourcePath];
  result = strdup([str cString]);
  [pool release];
  return result;
}

int
RBApplicationMain(const char* rb_main_name, int argc, char* argv[])
{
  int i;
  int ruby_argc;
  char** ruby_argv;
  int my_argc;
  char* my_argv[] = {
    "-I",
    resource_path(),
    "-I",
    osxobjc_resource_path(),
    rb_main_path(rb_main_name)
  };

  my_argc = sizeof(my_argv) / sizeof(char*);

  ruby_argc = 0;
  ruby_argv = malloc (sizeof(char*) * (argc + my_argc + 1));
  for (i = 0; i < argc; i++) {
    if (strncmp(argv[i], "-psn_", 5) == 0) continue;
    ruby_argv[ruby_argc++] = argv[i];
  }
  for (i = 0; i < my_argc; i++) ruby_argv[ruby_argc++] = my_argv[i];
  ruby_argv[ruby_argc] = NULL;

  ruby_init();
  ruby_options(ruby_argc, ruby_argv);
  ruby_run();
  return 0;
}


/////

static void* alloc_from_default_zone(unsigned int size)
{
  return NSZoneMalloc(NSDefaultMallocZone(), size);
}

static struct objc_method_list** method_list_alloc(int cnt)
{
  int i;
  struct objc_method_list** mlp;
  mlp = alloc_from_default_zone(cnt * sizeof(void*));
  for (i = 0; i < (cnt-1); i++)
    mlp[i] = NULL;
  mlp[cnt-1] = (struct objc_method_list*)-1; // END_OF_METHODS_LIST
  return mlp;
}

static Class objc_class_alloc(const char* name, Class super_class)
{
  Class c = alloc_from_default_zone(sizeof(struct objc_class));
  Class isa = alloc_from_default_zone(sizeof(struct objc_class));
  struct objc_method_list **mlp0, **mlp1;
  mlp0 = method_list_alloc(16);
  mlp1 = method_list_alloc(4);

  c->isa = isa;
  c->super_class = super_class;
  c->name = strdup(name);
  c->version = 0;
  c->info = CLS_CLASS + CLS_METHOD_ARRAY;
  c->instance_size = super_class->instance_size;
  c->ivars = NULL;
  c->methodLists = mlp0;
  c->cache = NULL;
  c->protocols = NULL;

  isa->isa = super_class->isa->isa;
  isa->super_class = super_class->isa;
  isa->name = c->name;
  isa->version = 5;
  isa->info = CLS_META + CLS_INITIALIZED + CLS_METHOD_ARRAY;
  isa->instance_size = super_class->isa->instance_size;
  isa->ivars = NULL;
  isa->methodLists = mlp1;
  isa->cache = NULL;
  isa->protocols = NULL;
  return c;
}

static void install_ivar_list(Class c)
{
  int i;
  struct objc_ivar_list* ivlp = alloc_from_default_zone(override_mixin_ivar_list_size());
  *ivlp = *(override_mixin_ivar_list());
  for (i = 0; i < ivlp->ivar_count; i++) {
    const char* tp = ivlp->ivar_list[i].ivar_type;
    int octype = to_octype(ivlp->ivar_list[i].ivar_type);
    ivlp->ivar_list[i].ivar_offset = c->instance_size;
    c->instance_size += ocdata_size(octype, tp);
  }
  c->ivars = ivlp;
}

static void install_method_list(Class c)
{
  class_addMethods(c, override_mixin_method_list());
}

static void install_class_method_list(Class c)
{
  class_addMethods((c->isa), override_mixin_class_method_list());
}


/**
 * Dictionary for Ruby class from  Objective-C class name
 **/
static NSMutableDictionary* class_dic_name_to_value()
{
  static NSMutableDictionary* dic = nil;
  if (!dic) dic = [[NSMutableDictionary alloc] init];
  return dic;
}

/**
 * Dictionary for Objective-C class name from Ruby class
 **/
static NSMutableDictionary* class_dic_value_to_name()
{
  static NSMutableDictionary* dic = nil;
  if (!dic) dic = [[NSMutableDictionary alloc] init];
  return dic;
}

/**
 * add class map entry to dictionaries.
 **/
static void class_map_dic_add (const char* name, VALUE kls)
{
  NSString* kls_name;
  NSNumber* kls_value;

  kls_name = [[NSString alloc] initWithCString: name];
  kls_value = [[NSNumber alloc] initWithUnsignedLong: kls];
  [class_dic_name_to_value() setObject: kls_value forKey: kls_name];
  [class_dic_value_to_name() setObject: kls_name forKey: kls_value];
  [kls_name release];
  [kls_value release];
}


Class RBOCObjcClassFromRubyClass (VALUE kls)
{
  id pool;
  NSDictionary* dic;
  NSNumber* kls_value;
  NSString* kls_name;
  Class result = nil;

  dic = class_dic_value_to_name();
  pool = [[NSAutoreleasePool alloc] init];

  kls_value = [NSNumber numberWithUnsignedLong: kls];
  kls_name = [dic objectForKey: kls_value];
  result = NSClassFromString (kls_name);
  [pool release];
  return result;
}

VALUE RBOCRubyClassFromObjcClass (Class cls)
{
  id pool;
  NSDictionary* dic;
  NSNumber* kls_value;
  NSString* kls_name;
  VALUE result = Qnil;

  dic = class_dic_name_to_value();
  pool = [[NSAutoreleasePool alloc] init];

  kls_name = NSStringFromClass(cls);
  kls_value = [dic objectForKey: kls_name];
  result = [kls_value unsignedLongValue];
  [pool release];
  return result;
}

Class RBOCClassNew(VALUE kls, const char* name, Class super_class)
{
  Class c;

  c = objc_class_alloc(name, super_class);
  objc_addClass(c);
  class_map_dic_add (name, kls);
  return c;
}

Class RBOCDerivedClassNew(VALUE kls, const char* name, Class super_class)
{
  Class c;

  c = objc_class_alloc(name, super_class);

  // init instance variable (m_proxy)
  install_ivar_list(c);

  // init instance methods
  install_method_list(c);

  // init class methods
  install_class_method_list(c);

  // add class to runtime system
  objc_addClass(c);
  class_map_dic_add (name, kls);
  return c;
}

