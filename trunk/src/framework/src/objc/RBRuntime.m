/** -*-objc-*-
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

#import <Foundation/NSThread.h>
#include <objc/objc-runtime.h>
#include <dlfcn.h>

#import "st.h"


#define RUBY_MAIN_NAME "rb_main.rb"

static char* rb_main_path(const char* rb_main_name)
{
  char* result;
  id path;
  id pool = [[NSAutoreleasePool alloc] init];
  NSBundle* bundle = [NSBundle mainBundle];
  if (rb_main_name == NULL) rb_main_name = RUBY_MAIN_NAME;
  path = [NSString stringWithUTF8String: rb_main_name];
  result = strdup([[bundle pathForResource: path ofType: nil] fileSystemRepresentation]);
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
  result = strdup([str fileSystemRepresentation]);
  [pool release];
  return result;
}

static char* framework_ruby_path()
{
  NSString* str;
  char* result;
  const char* dirname = "/ruby";
  id pool = [[NSAutoreleasePool alloc] init];
  NSBundle* bundle = [NSBundle bundleForClass: [RBObject class]];
  str = [bundle resourcePath];
  result = (char*) malloc (strlen([str fileSystemRepresentation]) + strlen(dirname) + 1);
  strcpy (result, [str fileSystemRepresentation]);
  strcat (result, dirname);
  [pool release];
  return result;
}

static void load_path_unshift(const char* path)
{
  extern VALUE rb_load_path;
  rb_ary_unshift(rb_load_path, rb_str_new2(path));
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
RBApplicationMain(const char* rb_main_name, int argc, const char* argv[])
{
  int ruby_argc;
  const char** ruby_argv;

  ruby_argc = prepare_argv(argc, argv, rb_main_name, &ruby_argv);

  ruby_init();
  ruby_options(ruby_argc, (char**) ruby_argv);
  RBRubyCocoaInit();
  load_path_unshift(resource_path()); // add a ruby part of oneself to $LOAD_PATH
  ruby_run();
  return 0;
}

#ifndef RUBY_THREADSWITCH_INIT
typedef unsigned int rb_threadswitch_event_t;

#define RUBY_THREADSWITCH_INIT 0x01
#define RUBY_THREADSWITCH_FREE 0x02
#define RUBY_THREADSWITCH_SAVE 0x04
#define RUBY_THREADSWITCH_RESTORE 0x08

typedef void (*rb_threadswitch_hook_func_t) _((rb_threadswitch_event_t,VALUE));

#endif

extern void *rb_add_threadswitch_hook(rb_threadswitch_hook_func_t func) __attribute__ ((weak_import));
extern void rb_remove_threadswitch_hook(void *handle) __attribute__ ((weak_import));

// Offsets into NSThread object of important instance vars
static int rb_cocoa_NSThread_autoreleasePool;
static int rb_cocoa_NSThread_excHandlers;
static struct st_table *rb_cocoa_thread_state;

#define NSTHREAD_autoreleasePool(t) (*(void**)( ((char*)t) + rb_cocoa_NSThread_autoreleasePool ))
#define NSTHREAD_excHandlers(t) (*(void**)( ((char*)t) + rb_cocoa_NSThread_excHandlers ))

struct rb_cocoa_thread_context
{
  void *excHandlers;
  void *autoreleasePool;
};

static void* rb_cocoa_thread_init_context(VALUE rbthread)
{
  struct rb_cocoa_thread_context *ctx;
  NSThread *thread = [NSThread currentThread];
  
  ctx = malloc(sizeof(*ctx));
  ctx->excHandlers = nil;
  ctx->autoreleasePool = nil;
  
  if (thread) {
    if (rbthread == rb_thread_current()) {
      ctx->excHandlers = NSTHREAD_excHandlers(thread);
      ctx->autoreleasePool = NSTHREAD_autoreleasePool(thread);
    } else {
      // Create a new autorelease pool for when this thread gets switched in
      void *save = NSTHREAD_autoreleasePool(thread);
      NSTHREAD_autoreleasePool(thread) = nil;
      //[[NSAutoreleasePool alloc] init]; // disabled for now
      ctx->autoreleasePool = NSTHREAD_autoreleasePool(thread);
      NSTHREAD_autoreleasePool(thread) = save;
    }
  }
  
  return ctx;
}

static void rb_cocoa_thread_free_context(struct rb_cocoa_thread_context *ctx)
{
    if (ctx)
        free(ctx);
}


static void rb_cocoa_thread_restore_context(struct rb_cocoa_thread_context *ctx)
{
    NSThread *thread = [NSThread currentThread];
    
    if (ctx && thread) {
        NSTHREAD_excHandlers(thread) = ctx->excHandlers;
        NSTHREAD_autoreleasePool(thread) = ctx->autoreleasePool;
    }
}



static void rb_cocoa_thread_save_context(struct rb_cocoa_thread_context *ctx)
{
    NSThread *thread = [NSThread currentThread];
        
    if (thread) {
        ctx->excHandlers = NSTHREAD_excHandlers(thread);
        ctx->autoreleasePool = NSTHREAD_autoreleasePool(thread);
    }
}


static void rb_cocoa_thread_schedule_hook(rb_threadswitch_event_t event, VALUE thread)
{
    void *context;
    
    switch (event) {
        case RUBY_THREADSWITCH_INIT:
            context = rb_cocoa_thread_init_context(thread);
            st_insert(rb_cocoa_thread_state, (st_data_t)thread, (st_data_t)context);
            break;
            
        case RUBY_THREADSWITCH_FREE:
            if (st_delete(rb_cocoa_thread_state, (st_data_t*)&thread, (st_data_t *)&context)) {
            	rb_cocoa_thread_free_context((struct rb_cocoa_thread_context*) context);
            }
            break;
        case RUBY_THREADSWITCH_SAVE:
            if (!st_lookup(rb_cocoa_thread_state, (st_data_t)thread, (st_data_t *)&context)) {
                context = rb_cocoa_thread_init_context(thread);
                st_insert(rb_cocoa_thread_state, (st_data_t)thread, (st_data_t)context);
            }
            rb_cocoa_thread_save_context((struct rb_cocoa_thread_context*) context);
            break;
            
        case RUBY_THREADSWITCH_RESTORE:
            if (st_lookup(rb_cocoa_thread_state, (st_data_t)thread, (st_data_t *)&context)) {
            	rb_cocoa_thread_restore_context((struct rb_cocoa_thread_context*) context);
            }
            break;
    }
}

static void RBCocoaInstallRubyThreadSchedulerHooks()
{
  Class nsthread;
  Ivar v;
  
  if (rb_add_threadswitch_hook==0) {
    if (getenv("RBCOCOA_DEBUG")!=0) {
      fprintf(stderr,"RBCocoaInstallRubyThreadSchedulerHooks: warning: rb_set_cocoa_thread_hooks not linked\n");
    }
    return;
  }
  
  rb_cocoa_thread_state = st_init_numtable();
  
  nsthread = objc_lookUpClass("NSThread");
  if (!nsthread) {
    fprintf(stderr,"RBCocoaInstallRubyThreadSchedulerHooks: couldn't find NSThread class\n");
    return;
  }
  
  v = class_getInstanceVariable(nsthread, "autoreleasePool");
  if (!v) {
    fprintf(stderr,"RBCocoaInstallRubyThreadSchedulerHooks: couldn't find autoreleasePool ivar\n");
    return;
  }
  
  rb_cocoa_NSThread_autoreleasePool = v->ivar_offset;
  
  if (rb_cocoa_NSThread_autoreleasePool != 24) {
    fprintf(stderr,"WARNING: RBCocoaInstallRubyThreadSchedulerHooks autoreleasePool not 24\n");
  }
  
  v = class_getInstanceVariable(nsthread, "excHandlers");
  if (!v) {
    fprintf(stderr,"RBCocoaInstallRubyThreadSchedulerHooks: couldn't find excHandlers ivar\n");
    return;
  }
  
  rb_cocoa_NSThread_excHandlers = v->ivar_offset;
  
  if (rb_cocoa_NSThread_excHandlers != 20) {
    fprintf(stderr,"WARNING: RBCocoaInstallRubyThreadSchedulerHooks autoreleasePool not 20\n");
  }
  
  rb_add_threadswitch_hook(rb_cocoa_thread_schedule_hook);
}

int
RBRubyCocoaInit()
{
  static int init_p = 0;

  if (init_p) return 0;

  RBCocoaInstallRubyThreadSchedulerHooks();
  ruby_init();
  load_path_unshift(framework_ruby_path()); // add a ruby part of rubycocoa to $LOAD_PATH
  initialize_mdl_osxobjc();	// initialize an objc part of rubycocoa
  init_p = 1;

  return 1;
}
