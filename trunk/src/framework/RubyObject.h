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

#import <Foundation/NSObject.h>

@interface RubyObject : NSObject
{
  id dummy;			// DummyProtocolHandler
  unsigned long rbobj;
}

+ rubyObjectWithOCObject: (id)a_ocobj;

- init;
- initWithRubyClassName: (NSString*)a_rbclass_name;
- initWithOCObject: (id)a_ocobj;
- initWithRubyClassName: (NSString*)a_rbclass_name ocObject: (id)a_ocobj;
- initWithRubyObject: (unsigned long)a_rbobj;

- (BOOL) hasObjcHandlerForSelector: (SEL)a_sel;
- (BOOL) hasRubyHandlerForSelector: (SEL)a_sel;

@end
