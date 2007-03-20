/** -*-objc-*-
 *
 *   $Id: /branches/thread-schedule/framework/src/objc/RBSlaveObject.h.in 980 2006-05-29T01:18:25.000000Z hisa  $
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/
#import <RubyCocoa/RBObject.h>
#import <RubyCocoa/osx_ruby.h>

@interface RBObject(RBSlaveObject)
- initWithMasterObject: master;
- initWithClass: (Class)occlass masterObject: master;
- initWithRubyClass: (VALUE)rbclass masterObject: master;
@end
