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
 *   To build with static libruby:
 *   cc -I/usr/lib/ruby/1.6/powerpc-darwin6.0 -framework Foundation \
 *      /usr/lib/ruby/1.6/powerpc-darwin6.0/libruby.a main_using_libruby.m \
 *      -o  {AppName}.app/Contents/MacOS/{APPNAME}
 *
 *   To build with dynamic libruby:
 *   cc -I/usr/lib/ruby/1.6/powerpc-darwin6.0 -framework Foundation \
 *      -lruby main_using_libruby.m -o  {AppName}.app/Contents/MacOS/{APPNAME}
 *
 **/

#import <unistd.h>
#import <string.h>
#import <stdlib.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSDictionary.h>
#import "ruby.h"

#define DEFAULT_RUBY_PROGRAM "/usr/bin/ruby"
#define DEFAULT_MAIN_SCRIPT  "rb_main.rb"

struct ruby_cocoa_app_config {
  char* ruby_program;
  char* main_script;
  char* resource_dir;
};

static void
exit_with_msg (const char* msg)
{
  NSLog (@"%s", msg);
  exit (1);
}

static void
load_config(struct ruby_cocoa_app_config* conf)
{
  NSAutoreleasePool* pool;
  NSBundle* bundle;
  NSDictionary* dic;
  NSString* str;

  pool = [[NSAutoreleasePool alloc] init];
  bundle = [NSBundle mainBundle];

  /* ruby application config */
  dic = [bundle objectForInfoDictionaryKey: @"RubyAppConfig"];

  if (dic == nil) {
    /* default ruby program */
    conf->ruby_program = DEFAULT_RUBY_PROGRAM;

    /* default main script path */
    str = [NSString stringWithCString: DEFAULT_MAIN_SCRIPT];
    str = [bundle pathForResource: str ofType: nil];
    if (str == nil) exit_with_msg ("config error: DEFAULT_MAIN_SCRIPT missing");
    conf->main_script = strdup ([str cString]);
  }

  else {
    /* ruby program */
    str = [dic objectForKey: @"RubyProgram"];
    if (str == nil) exit_with_msg ("config error: RubyProgram missing.");
    conf->ruby_program = strdup ([str cString]);

    /* main script path */
    str = [dic objectForKey: @"MainScript"];
    if (str == nil) exit_with_msg ("config error: MainScript missing.");
    str = [bundle pathForResource: str ofType: nil];
    if (str == nil) exit_with_msg ("config error: path of MainScript missing.");
    conf->main_script = strdup ([str cString]);
  }

  /* resource dir */
  str = [bundle resourcePath];
  if (str == nil) exit_with_msg ("config error: resourcePath missing.");
  conf->resource_dir = strdup ([str cString]);

  [pool release];
}

static char**
create_ruby_argv(const struct ruby_cocoa_app_config* conf, int argc, char* argv[], int* result_argc)
{
  int i;
  int ruby_argc;
  char** ruby_argv;
  int my_argc;
  char* my_argv[] = {
    "-I",
    conf->resource_dir,
    conf->main_script
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

  *result_argc = ruby_argc;
  return ruby_argv;
}

int
main(int argc, char* argv[])
{
  int ruby_argc;
  char** ruby_argv;
  struct ruby_cocoa_app_config conf;

  load_config (&conf);
  ruby_argv = create_ruby_argv(&conf, argc, argv, &ruby_argc);

  ruby_init();
  ruby_options(ruby_argc, ruby_argv);
  ruby_run();
  return 0;
}
