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
#import <RubyCocoa/RBObject.h>
#import <Foundation/Foundation.h>
#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>

static VALUE rbobj_for(VALUE rbclass, id master)
{
  return rb_funcall(rbclass, rb_intern("new"), 1, OCID2NUM(master));
}

static VALUE rbclass_for(Class occlass)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id name = NSStringFromClass(occlass);
  VALUE rbclass = rb_const_get(rb_cObject, rb_intern([name cString]));
  [pool release];
  return rbclass;
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
  VALUE rb_class = rbclass_for(occlass);
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
