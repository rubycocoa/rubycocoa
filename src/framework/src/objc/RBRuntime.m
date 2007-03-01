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

/* flag for calling Init_stack frequently */
static int frequently_init_stack_mode = 0;

void rubycocoa_set_frequently_init_stack(int val)
{
  frequently_init_stack_mode = (val ? 1 : 0);
}

int rubycocoa_frequently_init_stack()
{
  return frequently_init_stack_mode;
}

int RBNotifyException(const char* title, VALUE err)
{
  VALUE ary;
  int i;

  if (! RTEST(rb_obj_is_kind_of(err, rb_eException))) return 0;
  if (ruby_debug != Qtrue) return 0;
  NSLog(@"%s: %s: %s",
        title,
        STR2CSTR(rb_obj_as_string(rb_obj_class(err))),
        STR2CSTR(rb_obj_as_string(err)));
  ary = rb_funcall(err, rb_intern("backtrace"), 0);
  if (!NIL_P(ary)) {
    for (i = 0; i < RARRAY(ary)->len; i++) {
      NSLog(@"  %s\n", RSTRING(RARRAY(ary)->ptr[i])->ptr);
    }
  }
  return 1;
}

static int notify_if_error(const char* api_name, VALUE err)
{
  return RBNotifyException(api_name, err);
}

static int rubycocoa_initialized_flag = 0;

static int rubycocoa_initialized_p()
{
  return rubycocoa_initialized_flag;
}

static void rubycocoa_init()
{
  if (! rubycocoa_initialized_flag) {
    init_rb2oc_cache();    // initialize the Ruby->ObjC internal cache
    init_oc2rb_cache();    // initialize the ObjC->Ruby internal cache
    initialize_mdl_osxobjc();  // initialize an objc part of rubycocoa
    initialize_mdl_bundle_support();
    init_ovmix();
    load_path_unshift(framework_ruby_path()); // PATH_TO_FRAMEWORK/Resources/ruby
    rubycocoa_initialized_flag = 1;
  }
}

static VALUE
rubycocoa_bundle_init(const char* program, 
                      bundle_support_program_loader_t loader,
                      Class klass, id param)
{
  if (! rubycocoa_initialized_p()) {
    ruby_init();
    ruby_init_loadpath();
    rubycocoa_init();
    rubycocoa_set_frequently_init_stack(1);
  }
  load_path_unshift( resource_path_for( klass ));
  return loader(program, klass, param);
}

static VALUE
rubycocoa_app_init(const char* program, 
                   bundle_support_program_loader_t loader,
                   int argc, const char* argv[], id param)
{
  if (! rubycocoa_initialized_p()) {
    ruby_init();
    ruby_script(argv[0]);
    ruby_set_argv(argc - 1, (char**)(argv+1));
    ruby_init_loadpath();
    rubycocoa_init();
    rubycocoa_set_frequently_init_stack(0);
  }
  load_path_unshift(resource_path());
  return loader(program, nil, param);
}


/** [API] RBBundleInit
 *
 * initialize ruby and rubycocoa for a bundle
 * return not 0 when something error.
 */
int
RBBundleInit(const char* path_to_ruby_program, Class klass, id param)
{
  VALUE result;
  result = rubycocoa_bundle_init(path_to_ruby_program, 
                                 load_ruby_program_for_class, 
                                 klass, param);
  return notify_if_error("RBBundleInit", result);
}

int
RBBundleInitWithSource(const char* ruby_program, Class klass, id param)
{
  VALUE result;
  result = rubycocoa_bundle_init(ruby_program, 
                                 eval_ruby_program_for_class,
                                 klass, param);
  return notify_if_error("RBBundleInitWithSource", result);
}


/** [API] RBApplicationInit
 *
 * initialize ruby and rubycocoa for a command/application
 * return 0 when complete, or return not 0 when error.
 */
int
RBApplicationInit(const char* path_to_ruby_program, int argc, const char* argv[], id param)
{
  VALUE result;
  result = rubycocoa_app_init(path_to_ruby_program,
                              load_ruby_program_for_class,
                              argc, argv, param);
  return notify_if_error("RBApplicationInit", result);
}

int
RBApplicationInitWithSource(const char* ruby_program, int argc, const char* argv[], id param)
{
  VALUE result;
  result = rubycocoa_app_init(ruby_program, 
                              eval_ruby_program_for_class,
                              argc, argv, param);
  return notify_if_error("RBApplicationInitWithSource", result);
}

/** [API] initialize rubycocoa for a ruby extention library **/
void
RBRubyCocoaInit()
{
  rubycocoa_init();
}

/** [API] launch rubycocoa application (api for compatibility) **/
int
RBApplicationMain(const char* rb_program_path, int argc, const char* argv[])
{
  int ruby_argc;
  const char** ruby_argv;

  if (! rubycocoa_initialized_p()) {
    ruby_init();
    ruby_argc = prepare_argv(argc, argv, rb_program_path, &ruby_argv);
    ruby_options(ruby_argc, (char**) ruby_argv);
    rubycocoa_init();
    load_path_unshift(resource_path()); // PATH_TO_BUNDLE/Contents/resources
    ruby_run();
  }
  return 0;
}
