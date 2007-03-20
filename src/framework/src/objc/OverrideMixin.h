/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/
#import <objc/objc-class.h>
#import <Foundation/NSObject.h>
#import "osx_ruby.h"

void init_ovmix(void);

void install_ovmix_ivars(Class c);
void install_ovmix_methods(Class c);
void install_ovmix_class_methods(Class c);

@interface NSObject (__rbobj__)
+ (VALUE)__rbclass__;
@end
