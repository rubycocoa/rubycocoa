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

#import "RubyController.h"

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
  NSBundle* bundle = [NSBundle bundleForClass: [RubyController class]];
  str = [bundle resourcePath];
  result = strdup([str cString]);
  [pool release];
  return result;
}

int
rb_main(const char* rb_main_name, int argc, char* argv[])
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
