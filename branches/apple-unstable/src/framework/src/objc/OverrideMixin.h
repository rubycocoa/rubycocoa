/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/
#import <objc/objc-class.h>
#import <Foundation/NSObject.h>

long override_mixin_ivar_list_size();
struct objc_ivar_list* override_mixin_ivar_list();

struct objc_method_list* override_mixin_method_list();
struct objc_method_list* override_mixin_class_method_list();

void init_ovmix(void);

