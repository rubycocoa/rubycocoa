/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001-2007 FUJIMOTO Hisakuni
 *
 **/

#ifndef _RUBYCOCOA_H_
#define _RUBYCOCOA_H_

#import <RubyCocoa/RBRuntime.h>
#import <Foundation/NSObject.h>

@interface RubyCocoa : NSObject
+ (int) bundleInitWithProgram: (const char*) path_to_ruby_program
			class: (Class) objc_class
			param: (id) additional_param;

+ (int) applicationInitWithProgram: (const char*) path_to_ruby_program
			      argc: (int) argc
			      argv: (const char**) argv
			     param: (id) additional_param;

+ (int) applicationMainWithProgram: (const char*) path_to_ruby_program
			      argc: (int) argc
			      argv: (const char**) argv;
@end

#endif
