//
//  RubyInjectBundle.m
//  RubyInject
//
//  Created by Laurent Sansonetti on 10/2/07.
//  Copyright 2007 Laurent Sansonetti. Some rights reserved. 
//  <http://creativecommons.org/licenses/by/2.0/>
//

#import <Cocoa/Cocoa.h>
#import <ruby.h>
#import <assert.h>
#import <sys/syslimits.h>

static char *
DrObjectPath (char *buf, size_t buflen)
{
  CFBundleRef bundle;
  CFURLRef scriptURL;
  
  bundle = CFBundleGetBundleWithIdentifier(CFSTR("be.chopine.RubyInjectBundle"));
  assert(bundle != NULL);
  
  scriptURL = CFBundleCopyResourceURL(bundle, CFSTR("DrObject.rb"), NULL, NULL);
  assert(scriptURL != NULL);

  assert(CFURLGetFileSystemRepresentation(scriptURL, true, (UInt8 *)buf, buflen));

  CFRelease(scriptURL);
  CFRelease(bundle);
  
  return buf;
}

static char *
ExecutableName (char *buf, size_t buflen)
{
  ProcessSerialNumber psn;
  CFStringRef procName;
  
  GetCurrentProcess(&psn);
  CopyProcessName(&psn, &procName);
  
  CFStringGetFileSystemRepresentation(procName, buf, buflen);
  
  CFRelease(procName);
  
  return buf;
}

static void *
ThreadEntry (void *context)
{
  char path[PATH_MAX];

  NSLog(@"RubyInject ...");

  [[NSAutoreleasePool alloc] init];

  [NSThread detachNewThreadSelector:@selector(version) toTarget:[NSObject class] withObject:nil];
  
  ruby_init();
  ruby_init_loadpath();

  ruby_script(ExecutableName(path, sizeof path));
  rb_load_file(DrObjectPath(path, sizeof path));

  NSLog(@"RubyInject done!");

  ruby_run();

  return NULL;
}

__attribute__((constructor)) static void 
RubyInjectBundleInit (void) 
{
  pthread_t thread;
  pthread_create(&thread, NULL, ThreadEntry, NULL);
}
