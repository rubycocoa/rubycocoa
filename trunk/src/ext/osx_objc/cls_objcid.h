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

#ifndef _CLS_OBJCID_H_
#define _CLS_OBJCID_H_

#import <objc/objc.h>
#import <LibRuby/cocoa_ruby.h>

VALUE rb_objcid();
VALUE rb_objcid_s_new(id ocid);
id    rb_objcid_ocid(VALUE rcv);

#endif
