//
//  ocexception.h
//  RubyCocoa
//
//  Created by Laurent Sansonetti on 1/12/07.
//  Copyright 2007 Apple Inc. All rights reserved.
//

#import "osx_ruby.h"
#import <Foundation/Foundation.h>

VALUE ocdataconv_err_class(void);
VALUE oc_err_class(void);
VALUE ocmsgsend_err_class(void);

VALUE rb_err_new(VALUE klass, const char *fmt, ...);
VALUE oc_err_new(NSException* nsexcp);