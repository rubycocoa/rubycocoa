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
#import <objc/objc.h>
#import <Foundation/NSObject.h>
#import <LibRuby/cocoa_ruby.h>

int RBApplicationMain(const char* rb_main_name, int argc, char* argv[]);

Class RBOCObjcClassFromRubyClass (VALUE kls);
VALUE RBOCRubyClassFromObjcClass (Class cls);

Class RBOCClassNew(VALUE kls, const char* name, Class super_class);
Class RBOCDerivedClassNew(VALUE kls, const char* name, Class super_class);

@interface NSObject(RBOverrideMixin)
- __slave__;
- (VALUE) __rbobj__;
+ addRubyMethod: (SEL)a_sel;
@end

