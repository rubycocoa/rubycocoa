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

#ifndef _MDL_OBJWRAPPER_H_
#define _MDL_OBJWRAPPER_H_

#import <objc/objc.h>
#import <LibRuby/cocoa_ruby.h>

id    rb_objwrapper_ocid(VALUE rcv);
VALUE rb_objwrapper();

#endif
