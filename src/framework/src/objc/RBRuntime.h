/*
 * Copyright (c) 2006-2008, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#ifndef _RBRUNTIME_H_
#define _RBRUNTIME_H_

#import <objc/objc.h>

/*!
 * @header RubyCocoa/RBRuntime.h
 * @abstract RubyCocoa Runtime APIs.
 * @unsorted
 */

/*!
 * @functiongroup Runtime API functions
 */

/*!
 * @abstract initialize ruby and rubycocoa for a bundle.
 *
 * @param path_to_ruby_program Name of ruby script that run at load.
 * @param objc_class Class for detecting Bundle to load.
 * @param additional_param An optional object for initializing. It can be nil.
 * see @link RBApplicationInit() @/link.
 *
 * @result 0 when complete, or not 0 when error.
 *
 */
int RBBundleInit (const char* path_to_ruby_program,
                  Class       objc_class,
                  id          additional_param);


/*!
 * @abstract initialize ruby and rubycocoa for an application.
 *
 * @param path_to_ruby_program Name of ruby script that run at launch.
 * @param argc Count of arguments.
 * @param argv Values of argucments.
 * @param additional_param An optional object for initializing. It can be nil.
 * The value can be taken via OSX::BundleSupport._current_bundle()
 * in initializing ruby script.
 *
 * @result 0 when complete, or not 0 when error.
 *
 * @discussion An example of main.m of RubyCocoa applications:
 * <pre>
 * @textblock
 *      int main(int argc, const char* argv[])
 *      {
 *          RBApplicationInit("rb_main.rb", argc, argv, nil);
 *          return NSApplicationMain(argc, argv);
 *      }
 * @/textblock
 * </pre>
 */
int RBApplicationInit (const char* path_to_ruby_program,
                       int         argc,
                       const char* argv[],
                       id          additional_param);

/*!
 * @functiongroup Runtime API functions (deprecated)
 */

/*!
 * @abstract deperecated, use @link RBBundleInit() @/link.
 * @deprecated in version 1.0.3
 */
void RBRubyCocoaInit (void);


/*!
 * @abstract deperecated, use @link RBApplicationInit() @/link and NSApplicationMain().
 * @deprecated in version 1.0.3
 */
int
RBApplicationMain (const char* path_to_ruby_program,
                   int         argc,
                   const char* argv[]);

/** [API] RBIsRubyThreadingSupported
 *
 * verify if this environment supports the Ruby threading
 */
BOOL RBIsRubyThreadingSupported (void);

#endif  /* _RBRUNTIME_H_ */
