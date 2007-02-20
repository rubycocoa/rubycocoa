/** -*- mode:objc; indent-tabs-mode:nil -*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/

#import "RBRuntime.h"
#import "RBObject.h"
#import <string.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>
#import <Foundation/NSPathUtilities.h>
#import "mdl_osxobjc.h"
#import "mdl_bundle_support.h"
#import "ocdata_conv.h"
#import "OverrideMixin.h"
#import "internal_macros.h"

#define RUBY_MAIN_NAME "rb_main.rb"

/* this function should be called from inside a NSAutoreleasePool */
static NSBundle* bundle_for(Class klass)
{
  return (klass == nil) ?
    [NSBundle mainBundle] : 
    [NSBundle bundleForClass: klass];
}

static char* resource_item_path_for(const char* item_name, Class klass)
{
  char* result;
  POOL_DO(pool) {
    NSBundle* bundle = bundle_for(klass);
    NSString* path = [NSString stringWithUTF8String: item_name];
    path = [bundle pathForResource: path ofType: nil];
    result = strdup([path fileSystemRepresentation]);
  } END_POOL(pool);
  return result;
}

static char* resource_item_path(const char* item_name)
{
  return resource_item_path_for(item_name, nil);
}

static char* rb_main_path(const char* main_name)
{
  return resource_item_path(main_name);
}

static char* resource_path_for(Class klass)
{
  char* result;
  POOL_DO(pool) {
    NSBundle* bundle = bundle_for(klass);
    NSString* path = [bundle resourcePath];
    result = strdup([path fileSystemRepresentation]);
  } END_POOL(pool);
  return result;
}

static char* resource_path()
{
  return resource_path_for(nil);
}

static char* framework_ruby_path()
{
  return resource_item_path_for("ruby", [RBObject class]);
}

static void load_path_unshift(const char* path)
{
  extern VALUE rb_load_path;
  VALUE rpath = rb_str_new2(path);

  if (! RTEST(rb_ary_includes(rb_load_path, rpath)))
    rb_ary_unshift(rb_load_path, rpath);
}

static int
prepare_argv(int argc, const char* argv[], const char* rb_main_name, const char*** ruby_argv_ptr)
{
  int i;
  int ruby_argc;
  const char** ruby_argv;
  int my_argc;
  char* my_argv[] = {
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

  *ruby_argv_ptr = ruby_argv;
  return ruby_argc;
}

int
RBRubyCocoaInit()
{
  static int init_p = 0;
  if (init_p) return 0;

  ruby_init();
  load_path_unshift(framework_ruby_path()); // add a ruby part of rubycocoa to $LOAD_PATH
  init_rb2oc_cache(); // initialize the Ruby->ObjC internal cache
  init_oc2rb_cache(); // initialize the ObjC->Ruby internal cache
  initialize_mdl_osxobjc();	// initialize an objc part of rubycocoa
  initialize_mdl_bundle_support();
  init_ovmix();
  init_p = 1;

  return 1;
}

int
RBApplicationMain(const char* rb_main_name, int argc, const char* argv[])
{
  static int done_p = 0;
  int ruby_argc;
  const char** ruby_argv;

  if (done_p) return 0;
  done_p = 1;

  ruby_argc = prepare_argv(argc, argv, rb_main_name, &ruby_argv);

  ruby_init();
  ruby_options(ruby_argc, (char**) ruby_argv);
  RBRubyCocoaInit();
  load_path_unshift(resource_path()); // add a ruby part of oneself to $LOAD_PATH
  ruby_run();
  return 0;
}

BOOL
RBBundleInit(const char *rb_main_name, Class klass, id additional_param)
{
  extern void Init_stack(VALUE*);
  static int first_flg = 0;
  VALUE err;

  if (! first_flg) {
    ruby_init();
    ruby_init_loadpath();
    RBRubyCocoaInit();
    first_flg = 1;
  }
  load_path_unshift(resource_path_for(klass));
  err = bundle_support_load(rb_main_name, klass, additional_param);

  if (RTEST(rb_obj_is_kind_of(err, rb_eException)))
    return NO;
  else
    return YES;
}
