/* 
 * Copyright (c) 2006-2007, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

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

#define BRIDGE_SUPPORT_NAME "BridgeSupport"

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
    NSString* path = [bundle resourcePath];
    path = [path stringByAppendingFormat: @"/%@",
                 [NSString stringWithUTF8String: item_name]];
    if (path == NULL) {
      NSLog(@"ERROR: Cannot locate the bundle resource `%s' - aborting.", item_name);
      exit(1);
    }
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

static char* bridge_support_path_for(Class klass)
{
  return resource_item_path_for(BRIDGE_SUPPORT_NAME, klass);
}

static char* bridge_support_path()
{
  return bridge_support_path_for(nil);
}

static char* private_frameworks_path_for(Class klass)
{
  char* result;
  POOL_DO(pool) {
    NSBundle* bundle = bundle_for(klass);
    NSString* path = [bundle privateFrameworksPath];
    result = strdup([path fileSystemRepresentation]);
  } END_POOL(pool);
  return result;
}

static char* private_frameworks_path() { 
  return private_frameworks_path_for(nil);
}

static char* shared_frameworks_path_for(Class klass)
{
  char* result;
  POOL_DO(pool) {
    NSBundle* bundle = bundle_for(klass);
    NSString* path = [bundle sharedFrameworksPath];
    result = strdup([path fileSystemRepresentation]);
  } END_POOL(pool);
  return result;
}

static char* shared_frameworks_path() { 
  return shared_frameworks_path_for(nil);
}

char* framework_resources_path()
{
  return resource_path_for([RBObject class]);
}

static char* framework_ruby_path()
{
  return resource_item_path_for("ruby", [RBObject class]);
}

static char* framework_bridge_support_path()
{
  return bridge_support_path_for([RBObject class]);
}

static void load_path_unshift(const char* path)
{
  extern VALUE rb_load_path;
  VALUE rpath = rb_str_new2(path);

  if (! RTEST(rb_ary_includes(rb_load_path, rpath)))
    rb_ary_unshift(rb_load_path, rpath);
}

static void sign_path_unshift(const char* path)
{
  VALUE sign_paths;
  VALUE rpath;

  sign_paths = rb_const_get(osx_s_module(), rb_intern("RUBYCOCOA_SIGN_PATHS"));
  rpath = rb_str_new2(path);
  if (! RTEST(rb_ary_includes(sign_paths, rpath)))
    rb_ary_unshift(sign_paths, rpath);
}

static void framework_paths_unshift(const char* path)
{
  VALUE frameworks_paths;
  VALUE rpath;

  frameworks_paths = rb_const_get(osx_s_module(), rb_intern("RUBYCOCOA_FRAMEWORK_PATHS"));
  rpath = rb_str_new2(path);
  if (! RTEST(rb_ary_includes(frameworks_paths, rpath)))
    rb_ary_unshift(frameworks_paths, rpath);
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
  VALUE ary,str;
  VALUE printf_args[2];
  int i;

  if (! RTEST(rb_obj_is_kind_of(err, rb_eException))) return 0;
  if (! RUBYCOCOA_SUPPRESS_EXCEPTION_LOGGING_P) {
    NSLog(@"%s: %s: %s",
          title,
          STR2CSTR(rb_obj_as_string(rb_obj_class(err))),
          STR2CSTR(rb_obj_as_string(err)));
    ary = rb_funcall(err, rb_intern("backtrace"), 0);
    if (!NIL_P(ary)) {
      for (i = 0; i < RARRAY(ary)->len; i++) {
        printf_args[0] = rb_str_new2("\t%s\n");
        printf_args[1] = rb_ary_entry(ary, i);
        str = rb_f_sprintf(2, printf_args);
        rb_write_error(STR2CSTR(str));
      }
    }
  }
  return 1;
}

static int notify_if_error(const char* api_name, VALUE err)
{
  return RBNotifyException(api_name, err);
}

@implementation NSObject (__DeallocHook)

- (void) __dealloc
{
}

- (void) __clearCacheAndDealloc
{
  remove_from_oc2rb_cache(self);
  [self __dealloc];
}

@end

static void install_dealloc_hook()
{
  Method dealloc_method, aliased_dealloc_method, cache_aware_dealloc_method;
  Class nsobject;

  nsobject = [NSObject class];

  dealloc_method = class_getInstanceMethod(nsobject, @selector(dealloc));
  aliased_dealloc_method = class_getInstanceMethod(nsobject, 
    @selector(__dealloc));
  cache_aware_dealloc_method = class_getInstanceMethod(nsobject,
    @selector(__clearCacheAndDealloc));

  method_setImplementation(aliased_dealloc_method,
    method_getImplementation(dealloc_method));
  method_setImplementation(dealloc_method,
    method_getImplementation(cache_aware_dealloc_method));
}


static int rubycocoa_initialized_flag = 0;

static int rubycocoa_initialized_p()
{
  return rubycocoa_initialized_flag;
}

// exported and used by internal_macros.h 
VALUE rubycocoa_debug = Qfalse;

static void rubycocoa_init()
{
  if (! rubycocoa_initialized_flag) {
    init_rb2oc_cache();    // initialize the Ruby->ObjC internal cache
    init_oc2rb_cache();    // initialize the ObjC->Ruby internal cache
    install_dealloc_hook();
    initialize_mdl_osxobjc();  // initialize an objc part of rubycocoa
    initialize_mdl_bundle_support();
    init_ovmix();
    load_path_unshift(framework_ruby_path()); // PATH_TO_FRAMEWORK/Resources/ruby
    sign_path_unshift(framework_bridge_support_path());
    rubycocoa_initialized_flag = 1;
    rb_define_variable("$RUBYCOCOA_DEBUG", &ruby_debug);
  }
}

static VALUE
rubycocoa_bundle_init(const char* program, 
                      bundle_support_program_loader_t loader,
                      Class klass, id param)
{
  extern void Init_stack(VALUE*);
  int state;
  Init_stack((void*)&state);
  if (! rubycocoa_initialized_p()) {
    ruby_init();
    ruby_init_loadpath();
    rubycocoa_init();
    rubycocoa_set_frequently_init_stack(1);
  }
  load_path_unshift(resource_path_for(klass));
  sign_path_unshift(bridge_support_path_for(klass));
  framework_paths_unshift(private_frameworks_path_for(klass));
  framework_paths_unshift(shared_frameworks_path_for(klass));
  return loader(program, klass, param);
}

static VALUE
rubycocoa_app_init(const char* program, 
                   bundle_support_program_loader_t loader,
                   int argc, const char* argv[], id param)
{
  extern void Init_stack(VALUE*);
  int state;
  Init_stack((void*)&state);
  if (! rubycocoa_initialized_p()) {
    ruby_init();
    ruby_script(argv[0]);
    ruby_set_argv(argc - 1, (char**)(argv+1));
    ruby_init_loadpath();
    rubycocoa_init();
    rubycocoa_set_frequently_init_stack(0);
  }
  load_path_unshift(resource_path());
  sign_path_unshift(bridge_support_path());
  framework_paths_unshift(private_frameworks_path());
  framework_paths_unshift(shared_frameworks_path());
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
    sign_path_unshift(bridge_support_path());
    framework_paths_unshift(private_frameworks_path());
    framework_paths_unshift(shared_frameworks_path());
    ruby_run();
  }
  return 0;
}
