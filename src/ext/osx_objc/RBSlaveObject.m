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
#import <Foundation/Foundation.h>
#import "RBRuntime.h"
#import "RBObject.h"
#import "osx_ruby.h"
#import "ocdata_conv.h"
#import "osx_objc.h"

static VALUE rbobj_for(VALUE rbclass, id master)
{
  return rb_funcall(rbclass, rb_intern("new_with_ocid"), 1, OCID2NUM(master));
}

@implementation RBObject(RBSlaveObject)

- init
{
  return [self initWithClass: [self class] masterObject: nil];
}

- initWithMasterObject: master
{
  return [self initWithClass: [self class] masterObject: master];
}

- initWithClass: (Class)occlass
{
  return [self initWithClass: occlass masterObject: nil];
}

- initWithClass: (Class)occlass masterObject: master
{
  VALUE rb_class = RBOCRubyClassFromObjcClass (occlass);
  return [self initWithRubyClass: rb_class masterObject: master];
}

///////

- initWithRubyClass: (VALUE)rbclass
{
  return [self initWithRubyClass: rbclass masterObject: nil];
}

- initWithRubyClass: (VALUE)rbclass masterObject: master
{
  VALUE rbobj = rbobj_for(rbclass, master);
  return [self initWithRubyObject: rbobj];
}

@end
