/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/
#import "osx_ruby.h"

/** class methods **/
VALUE objcptr_s_class ();
VALUE objcptr_s_new_with_cptr (void* cptr, const char *encoding);

/** instance methods **/
void* objcptr_cptr (VALUE rcv);
long objcptr_allocated_size(VALUE rcv);

/** initial loading **/
VALUE init_cls_ObjcPtr (VALUE outer);
