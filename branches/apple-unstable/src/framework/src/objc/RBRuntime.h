/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/

#define ASSERT_ALLOC(x) do { if (x == NULL) rb_fatal("can't allocate memory"); } while (0)

#define DLOG(mod, fmt, args...)                           \
  do {                                                    \
    if (ruby_debug == Qtrue) {                            \
      NSAutoreleasePool * pool;                           \
      NSString *          nsfmt;                          \
                                                          \
      pool = [[NSAutoreleasePool alloc] init];            \
      nsfmt = [NSString stringWithFormat:                 \
        [NSString stringWithFormat:@"%s : %s",            \
          mod, fmt], ##args];                             \
      NSLog(nsfmt);                                       \
      [pool release];                                     \
    }                                                     \
  }                                                       \
  while (0)

int RBApplicationMain(const char* rb_main_name, int argc, const char* argv[]);
int RBBundleInit(const char *rb_main_name, const char *class_name);

int RBRubyCocoaInit();
