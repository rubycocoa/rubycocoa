/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/

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

int RBRubyCocoaInit();
