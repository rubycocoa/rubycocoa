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

#import <LibRuby/cocoa_ruby.h>
#import "osx_ocobject.h"

#define OSX_MODULE_NAME "OSX"

static VALUE init_module_OSX()
{
  VALUE module;
  RB_ID id_osx = rb_intern(OSX_MODULE_NAME);

  if (rb_const_defined(rb_cObject, id_osx))
    module = rb_const_get(rb_cObject, id_osx);
  else
    module = rb_define_module(OSX_MODULE_NAME);
  return module;
}

void Init_osxobjc()
{
  VALUE mOSX, cOCObject;
  extern void init_cocoa(VALUE);

  mOSX = init_module_OSX();
  init_class_OCObject(mOSX);

  init_cocoa(mOSX);
}
