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


static VALUE rbobj_for(VALUE rbclass, VALUE arg, id master)
{
  
  VALUE rbobj = Qnil;
  if (master && rb_respond_to(rbclass, rb_intern("new_with_ocid"))) {
    VALUE rb_ocid = UINT2NUM((unsigned int)master);
    if (arg == Qnil)
      rbobj = rb_funcall(rbclass, rb_intern("new_with_ocid"), 1, rb_ocid);
    else
      rbobj = rb_funcall(rbclass, rb_intern("new_with_ocid"), 2, rb_ocid, arg);
  }
  else {
    if (arg == Qnil)
      rbobj = rb_funcall(rbclass, rb_intern("new"), 0);
    else
      rbobj = rb_funcall(rbclass, rb_intern("new"), 1, arg);
  }
  return rbobj;
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
  return [self initWithClass: occlass withArg: Qnil masterObject: master];
}

- initWithClass: (Class)occlass withArg: (VALUE)arg masterObject: master
{
  VALUE rb_class = rbclass_for(occlass);
  return [self initWithRubyClass: rb_class withArg: arg masterObject: master];
}

///////

- initWithRubyClass: (VALUE)rbclass
{
  return [self initWithRubyClass: rbclass masterObject: nil];
}

- initWithRubyClass: (VALUE)rbclass masterObject: master
{
  return [self initWithRubyClass: rbclass withArg: Qnil masterObject: master];
}

- initWithRubyClass: (VALUE)rbclass withArg: (VALUE)arg masterObject: master
{
  VALUE rbobj = rbobj_for(rbclass, arg, master);
  return [self initWithRubyObject: rbobj];
}

@end
