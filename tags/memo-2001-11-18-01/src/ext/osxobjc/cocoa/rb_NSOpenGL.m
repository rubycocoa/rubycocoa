#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSOpenGL(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSOpenGLGOFormatCacheSize", INT2NUM(NSOpenGLGOFormatCacheSize));
  rb_define_const(mOSX, "NSOpenGLGOClearFormatCache", INT2NUM(NSOpenGLGOClearFormatCache));
  rb_define_const(mOSX, "NSOpenGLGORetainRenderers", INT2NUM(NSOpenGLGORetainRenderers));
  rb_define_const(mOSX, "NSOpenGLGOResetLibrary", INT2NUM(NSOpenGLGOResetLibrary));
  rb_define_const(mOSX, "NSOpenGLPFAAllRenderers", INT2NUM(NSOpenGLPFAAllRenderers));
  rb_define_const(mOSX, "NSOpenGLPFADoubleBuffer", INT2NUM(NSOpenGLPFADoubleBuffer));
  rb_define_const(mOSX, "NSOpenGLPFAStereo", INT2NUM(NSOpenGLPFAStereo));
  rb_define_const(mOSX, "NSOpenGLPFAAuxBuffers", INT2NUM(NSOpenGLPFAAuxBuffers));
  rb_define_const(mOSX, "NSOpenGLPFAColorSize", INT2NUM(NSOpenGLPFAColorSize));
  rb_define_const(mOSX, "NSOpenGLPFAAlphaSize", INT2NUM(NSOpenGLPFAAlphaSize));
  rb_define_const(mOSX, "NSOpenGLPFADepthSize", INT2NUM(NSOpenGLPFADepthSize));
  rb_define_const(mOSX, "NSOpenGLPFAStencilSize", INT2NUM(NSOpenGLPFAStencilSize));
  rb_define_const(mOSX, "NSOpenGLPFAAccumSize", INT2NUM(NSOpenGLPFAAccumSize));
  rb_define_const(mOSX, "NSOpenGLPFAMinimumPolicy", INT2NUM(NSOpenGLPFAMinimumPolicy));
  rb_define_const(mOSX, "NSOpenGLPFAMaximumPolicy", INT2NUM(NSOpenGLPFAMaximumPolicy));
  rb_define_const(mOSX, "NSOpenGLPFAOffScreen", INT2NUM(NSOpenGLPFAOffScreen));
  rb_define_const(mOSX, "NSOpenGLPFAFullScreen", INT2NUM(NSOpenGLPFAFullScreen));
  rb_define_const(mOSX, "NSOpenGLPFARendererID", INT2NUM(NSOpenGLPFARendererID));
  rb_define_const(mOSX, "NSOpenGLPFASingleRenderer", INT2NUM(NSOpenGLPFASingleRenderer));
  rb_define_const(mOSX, "NSOpenGLPFANoRecovery", INT2NUM(NSOpenGLPFANoRecovery));
  rb_define_const(mOSX, "NSOpenGLPFAAccelerated", INT2NUM(NSOpenGLPFAAccelerated));
  rb_define_const(mOSX, "NSOpenGLPFAClosestPolicy", INT2NUM(NSOpenGLPFAClosestPolicy));
  rb_define_const(mOSX, "NSOpenGLPFARobust", INT2NUM(NSOpenGLPFARobust));
  rb_define_const(mOSX, "NSOpenGLPFABackingStore", INT2NUM(NSOpenGLPFABackingStore));
  rb_define_const(mOSX, "NSOpenGLPFAMPSafe", INT2NUM(NSOpenGLPFAMPSafe));
  rb_define_const(mOSX, "NSOpenGLPFAWindow", INT2NUM(NSOpenGLPFAWindow));
  rb_define_const(mOSX, "NSOpenGLPFAMultiScreen", INT2NUM(NSOpenGLPFAMultiScreen));
  rb_define_const(mOSX, "NSOpenGLPFACompliant", INT2NUM(NSOpenGLPFACompliant));
  rb_define_const(mOSX, "NSOpenGLPFAScreenMask", INT2NUM(NSOpenGLPFAScreenMask));
  rb_define_const(mOSX, "NSOpenGLCPSwapRectangle", INT2NUM(NSOpenGLCPSwapRectangle));
  rb_define_const(mOSX, "NSOpenGLCPSwapRectangleEnable", INT2NUM(NSOpenGLCPSwapRectangleEnable));
  rb_define_const(mOSX, "NSOpenGLCPRasterizationEnable", INT2NUM(NSOpenGLCPRasterizationEnable));
  rb_define_const(mOSX, "NSOpenGLCPSwapInterval", INT2NUM(NSOpenGLCPSwapInterval));
  rb_define_const(mOSX, "NSOpenGLCPStateValidation", INT2NUM(NSOpenGLCPStateValidation));

}
