/* 
 * Copyright (c) 2006-2008, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#import "RBRuntime.h"

/** [API] RBBundleInit
 *
 * initialize ruby and rubycocoa for a bundle
 * return not 0 when something error.
 */
int
RBBundleInit(const char* path_to_ruby_program, Class klass, id param)
{
  /* TODO */
  return 0;
}

int
RBBundleInitWithSource(const char* ruby_program, Class klass, id param)
{
  /* TODO */
  return 0;
}


/** [API] RBApplicationInit
 *
 * initialize ruby and rubycocoa for a command/application
 * return 0 when complete, or return not 0 when error.
 */
int
RBApplicationInit(const char* path_to_ruby_program, int argc, const char* argv[], id param)
{
  /* TODO */
  return 0;
}


/** [API] initialize rubycocoa for a ruby extention library **/
void
RBRubyCocoaInit()
{
  /* TODO */
  return;
}

/** [API] launch rubycocoa application (api for compatibility) **/
int
RBApplicationMain(const char* rb_program_path, int argc, const char* argv[])
{
  /* TODO */
  return 0;
}

BOOL RBIsRubyThreadingSupported (void)
{
  /* TODO */
  return NO;
}

