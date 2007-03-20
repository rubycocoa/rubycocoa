/** -*- mode:objc; indent-tabs-mode:nil -*-
 *
 *   mdl_bundle_support.h
 *   RubyCocoa
 *   $Id$
 *
 *  Created by Fujimoto Hisa on 2/8/07.
 *  Copyright 2007 Fujimoto Hisa, FOBJ SYSTEMS. All rights reserved.
 **/

#ifndef _MDL_BUNDLE_SUPPORT_H_
#define  _MDL_BUNDLE_SUPPORT_H_

#import <objc/objc.h>
#import "osx_ruby.h"

void initialize_mdl_bundle_support();

typedef VALUE (* bundle_support_program_loader_t)(const char*, Class, id);

VALUE load_ruby_program_for_class(const char* path,    Class objc_class, id additional_param);
VALUE eval_ruby_program_for_class(const char* program, Class objc_class, id additional_param);

#endif  //  _MDL_BUNDLE_SUPPORT_H_
