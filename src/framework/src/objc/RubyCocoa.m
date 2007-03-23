/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001-2007 FUJIMOTO Hisakuni
 *
 **/
#import <Foundation/Foundation.h>
#import <RubyCocoa/RubyCocoa.h>

@implementation RubyCocoa
+ (int) bundleInitWithProgram: (const char*) path_to_ruby_program
			class: (Class) objc_class
			param: (id) additional_param
{
  return RBBundleInit(path_to_ruby_program, objc_class, additional_param);
}

+ (int) applicationInitWithProgram: (const char*) path_to_ruby_program
			      argc: (int) argc
			      argv: (const char**) argv
			     param: (id) additional_param
{
  return RBApplicationInit(path_to_ruby_program, argc, argv, additional_param);
}

+ (int) applicationMainWithProgram: (const char*) path_to_ruby_program
			      argc: (int) argc
			      argv: (const char**) argv
{
  return RBApplicationMain(path_to_ruby_program, argc, argv);
}
@end
