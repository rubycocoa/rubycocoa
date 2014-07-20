/* 
 * Copyright (c) 2006-2008, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#ifndef _INTERNAL_MACROS_H_
#define _INTERNAL_MACROS_H_

#import <Foundation/Foundation.h>

#define RUBYCOCOA_SUPPRESS_EXCEPTION_LOGGING_P \
  RTEST(rb_gv_get("RUBYCOCOA_SUPPRESS_EXCEPTION_LOGGING"))

extern VALUE rubycocoa_debug;

#define RUBY_DEBUG_P      RTEST(ruby_debug)
#define RUBYCOCOA_DEBUG_P RTEST(rubycocoa_debug)
#define DEBUG_P           (RUBY_DEBUG_P || RUBYCOCOA_DEBUG_P)

extern VALUE rubycocoa_use_oc2rbCache;
#define RUBYCOCOA_USE_OC2RBCACHE_P RTEST(rubycocoa_use_oc2rbCache)

#define ASSERT_ALLOC(x) do { if (x == NULL) rb_fatal("can't allocate memory"); } while (0)

#define DLOG(mod, fmt, args...)                  \
  do {                                           \
    if (DEBUG_P) {                             \
      NSAutoreleasePool * pool;                  \
                                                 \
      pool = [[NSAutoreleasePool alloc] init];   \
      NSLog(@mod @" : " @fmt, ##args);           \
      [pool release];                            \
    }                                            \
  }                                              \
  while (0)

/* syntax: POOL_DO(the_pool) { ... } END_POOL(the_pool); */
#define POOL_DO(POOL)   { id POOL = [[NSAutoreleasePool alloc] init];
#define END_POOL(POOL)  [(POOL) release]; }

/* flag for calling Init_stack frequently */
extern int rubycocoa_frequently_init_stack();
#define FREQUENTLY_INIT_STACK_FLAG rubycocoa_frequently_init_stack()

extern NSThread *rubycocoaThread;
extern NSRunLoop *rubycocoaRunLoop;

#define DISPATCH_ON_RUBYCOCOA_THREAD(self, sel) \
  do { \
    assert(rubycocoaThread != nil); \
    [self performSelector:sel onThread:rubycocoaThread withObject:nil waitUntilDone:YES]; \
  } \
  while (0)

/* invoke-based undo requires some special handling on 10.6 */
#define IS_UNDOPROXY(obj) (object_getClass(obj) == objc_getClass("NSUndoManagerProxy"))

/* compatibility for older ruby versions */

/* Snow Leopard */
#ifndef RFLOAT_VALUE
#define RFLOAT_VALUE(x) (RFLOAT(x)->value)
#endif

/* ruby 2.0 renamed symbols from ruby 1.8 */
#ifdef HAVE_RUBY_RUBY_H
#define ruby_errinfo rb_errinfo()
#define is_ruby_native_thread ruby_native_thread_p
#define rb_frame_last_func rb_frame_this_func
#endif

#endif	// _INTERNAL_MACROS_H_
