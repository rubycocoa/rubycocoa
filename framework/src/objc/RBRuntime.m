/* 
 * Copyright (c) 2006-2008, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#import "RBRuntime.h"
#import <objc/objc-runtime.h>
#import <Foundation/Foundation.h>
#import <dlfcn.h>

/* expand RUBYCOCOA_DEFAULT_EXTENTION to @"path/to/bundle" */
#define TO_CSTR(macro) #macro
#define TO_NSSTR(macro) @ TO_CSTR(macro)

static int rubycocoa_ext_loaded = 0;

@interface RBFramework : NSObject {
  void* handle_;
}
+(instancetype)sharedInstance;
-(NSBundle*)bundle;
-(NSString*)defaultExtentionPath;

@property (readonly)NSBundle* bundle;
@end

@implementation RBFramework

static RBFramework* sharedInstance_;

+(instancetype)sharedInstance
{
  @synchronized(self) {
    if(!sharedInstance_) {
      sharedInstance_ = [[self alloc] init];
    }
  }
  return sharedInstance_;
}

-(instancetype)init
{
  self = [super init];
  _bundle = [NSBundle bundleForClass:[self class]];
  [_bundle retain];
  return self;
}

-(NSString*)defaultExtentionPath
{
  return [self.bundle pathForResource:TO_NSSTR(RUBYCOCOA_DEFAULT_EXTENTION) ofType:@"bundle"];
}

-(BOOL)loadRubyCocoaExtention
{
  NSString* extpath;

  if (rubycocoa_ext_loaded) {
    return YES;
  }
  extpath = [self defaultExtentionPath];
  handle_ = dlopen([extpath fileSystemRepresentation], RTLD_LAZY|RTLD_NODELETE);
  if (!handle_) {
    NSLog(@"Warning: ruby extention `%@' not loaded. (%s)", extpath, dlerror());
    return NO;
  }
  rubycocoa_ext_loaded = 1;
  return YES;
}

-(void)dealloc
{
  if (rubycocoa_ext_loaded) {
    dlclose(handle_);
  }
  [super dealloc];
}

@end

// class "RBRuntime" is implemented in rubycocoa.bundle
@protocol RBRuntime
+(id)sharedInstance;
//-(BOOL)registerFrameworkBundle:(NSBundle*)bundle;

-(int)setupBundleWithPath:(const char*)path_to_ruby_program bundleClass:(Class)klass associatedObject:(id)param;
-(int)setupApplicationWithPath:(const char*)path_to_ruby_program numberOfArguments:(int)argc argumentValues:(const char**)argv associatedObject:(id)param;
-(int)launchApplicationWithPath:(const char*)path_to_ruby_program numberOfArguments:(int)argc argumentValues:(const char**)argv;
-(BOOL)isRubyThreadingSupported;
@end
#define RBRuntimeKlass ((id)objc_getClass("RBRuntime"))
#define RBRuntimeObj ((id<RBRuntime>)[RBRuntimeKlass sharedInstance])
//#define RBRuntimeObj ((id<RBRuntime>)[[RBRuntimeKlass alloc] init])

/** [API] RBBundleInit
 *
 * initialize ruby and rubycocoa for a bundle
 * return not 0 when something error.
 */
int
RBBundleInit(const char* path_to_ruby_program, Class klass, id param)
{
  if (![[RBFramework sharedInstance] loadRubyCocoaExtention]) {
    NSLog(@"Error: RBBundleInit() failed at loading ruby extention.");
    return 1;
  }
  return [RBRuntimeObj setupBundleWithPath:path_to_ruby_program bundleClass:klass associatedObject:param];
}

/** [API] RBApplicationInit
 *
 * initialize ruby and rubycocoa for a command/application
 * return 0 when complete, or return not 0 when error.
 */
int
RBApplicationInit(const char* path_to_ruby_program, int argc, const char* argv[], id param)
{
  if (![[RBFramework sharedInstance] loadRubyCocoaExtention]) {
    NSLog(@"Error: RBApplicationInit() failed at loading ruby extention.");
    return 1;
  }
  return [RBRuntimeObj setupApplicationWithPath:path_to_ruby_program numberOfArguments:argc argumentValues:argv associatedObject:param];
}

/** [API] launch rubycocoa application (api for compatibility) **/
/* deprecated in version 1.0.3 */
int
RBApplicationMain(const char* rb_program_path, int argc, const char* argv[])
{
  NSLog(@"Warning: RBApplicationMain() is deprecated. "
                 @"Use RBApplicationInit() and NSApplicationMain().");
  if (![[RBFramework sharedInstance] loadRubyCocoaExtention]) {
    NSLog(@"Error: RBApplicationMain() failed at loading ruby extention.");
    return 1;
  }
  return [RBRuntimeObj launchApplicationWithPath:rb_program_path numberOfArguments:argc argumentValues:argv];
}

BOOL RBIsRubyThreadingSupported (void)
{
  if (!rubycocoa_ext_loaded) {
    return NO;
  }
  return [RBRuntimeObj isRubyThreadingSupported];
}

