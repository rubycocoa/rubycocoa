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
#import <RubyCocoa/osx_ruby.h>

@interface RBObject(RBSlaveObject)
- init;
- initWithMasterObject: master;
- initWithClass: (Class)occlass;
- initWithClass: (Class)occlass masterObject: master;
- initWithRubyClass: (VALUE)rbclass;
- initWithRubyClass: (VALUE)rbclass masterObject: master;
@end
