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

#import <RubyCocoa/RBProxy.h>

#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>


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
  NSBundle* bundle = [NSBundle bundleForClass: [RBProxy class]];
  str = [bundle resourcePath];
  result = strdup([str cString]);
  [pool release];
  return result;
}

int
RBApplicationMain(const char* rb_main_name, int argc, char* argv[])
{
  int private_argc;
  char* private_argv[] = {
    argv[0],
    "-I",
    resource_path(),
    "-I",
    osxobjc_resource_path(),
    rb_main_path(rb_main_name)
  };

  private_argc = sizeof(private_argv) / sizeof(char*);

  ruby_init();
  ruby_options(private_argc, private_argv);
  ruby_run();
  return 0;
}


/////

Class RBOCClassNew(const char* name, Class superclass)
{
  Class c = malloc(sizeof(struct objc_class));
  Class isa = malloc(sizeof(struct objc_class));
  struct objc_method_list **mlp0, **mlp1;
  mlp0 = malloc(sizeof(void*));
  mlp1 = malloc(sizeof(void*));
  *mlp0 = *mlp1 = NULL;

  c->isa = isa;
  c->super_class = superclass;
  c->name = strdup(name);
  c->version = 0;
  c->info = CLS_CLASS + CLS_METHOD_ARRAY;
  c->instance_size = superclass->instance_size;
  c->ivars = NULL;
  c->methodLists = mlp0;
  c->cache = NULL;
  c->protocols = NULL;

  isa->isa = superclass->isa->isa;
  isa->super_class = superclass->isa;
  isa->name = c->name;
  isa->version = 5;
  isa->info = CLS_META + CLS_INITIALIZED + CLS_METHOD_ARRAY;
  isa->instance_size = superclass->isa->instance_size;
  isa->ivars = NULL;
  isa->methodLists = mlp1;
  isa->cache = NULL;
  isa->protocols = NULL;

  objc_addClass(c);
  return c;
}
