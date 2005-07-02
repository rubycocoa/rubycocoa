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
#import "RBSlaveObject.h"
#import "RBRuntime.h"
#import "RBClassUtils.h"
#import "osx_ruby.h"
#import "ocdata_conv.h"
#import "mdl_osxobjc.h"

@implementation RBObject(RBSlaveObject)

- initWithMasterObject: master
{
  return [self initWithClass: [self class] masterObject: master];
}

- initWithClass: (Class)occlass masterObject: master
{
  VALUE rb_class = RBRubyClassFromObjcClass (occlass);
  return [self initWithRubyClass: rb_class masterObject: master];
}

///////

- initWithRubyClass: (VALUE)rbclass masterObject: master
{
  VALUE rbobj;
  rbobj = objcid_new(rbclass, master, NO);
  return [self initWithRubyObject: rbobj];
}

@end
