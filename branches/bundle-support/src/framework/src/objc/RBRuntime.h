/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/

#ifndef _RBRUNTIME_H_
#define _RBRUNTIME_H_

#import <objc/objc.h>

int  RBApplicationMain(const char* rb_main_name, int argc, const char* argv[]);
BOOL RBBundleInit(const char *rb_main_name, Class klass, id additional_param);

int RBRubyCocoaInit();

#endif	// _RBRUNTIME_H_
