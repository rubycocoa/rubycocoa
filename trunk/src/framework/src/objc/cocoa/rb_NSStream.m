#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSStreamSocketSecurityLevelKey;
static VALUE
osx_NSStreamSocketSecurityLevelKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSocketSecurityLevelKey, "NSStreamSocketSecurityLevelKey", nil);
}

// NSString * const NSStreamSocketSecurityLevelNone;
static VALUE
osx_NSStreamSocketSecurityLevelNone(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSocketSecurityLevelNone, "NSStreamSocketSecurityLevelNone", nil);
}

// NSString * const NSStreamSocketSecurityLevelSSLv2;
static VALUE
osx_NSStreamSocketSecurityLevelSSLv2(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSocketSecurityLevelSSLv2, "NSStreamSocketSecurityLevelSSLv2", nil);
}

// NSString * const NSStreamSocketSecurityLevelSSLv3;
static VALUE
osx_NSStreamSocketSecurityLevelSSLv3(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSocketSecurityLevelSSLv3, "NSStreamSocketSecurityLevelSSLv3", nil);
}

// NSString * const NSStreamSocketSecurityLevelTLSv1;
static VALUE
osx_NSStreamSocketSecurityLevelTLSv1(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSocketSecurityLevelTLSv1, "NSStreamSocketSecurityLevelTLSv1", nil);
}

// NSString * const NSStreamSocketSecurityLevelNegotiatedSSL;
static VALUE
osx_NSStreamSocketSecurityLevelNegotiatedSSL(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSocketSecurityLevelNegotiatedSSL, "NSStreamSocketSecurityLevelNegotiatedSSL", nil);
}

// NSString * const NSStreamSOCKSProxyConfigurationKey;
static VALUE
osx_NSStreamSOCKSProxyConfigurationKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSOCKSProxyConfigurationKey, "NSStreamSOCKSProxyConfigurationKey", nil);
}

// NSString * const NSStreamSOCKSProxyHostKey;
static VALUE
osx_NSStreamSOCKSProxyHostKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSOCKSProxyHostKey, "NSStreamSOCKSProxyHostKey", nil);
}

// NSString * const NSStreamSOCKSProxyPortKey;
static VALUE
osx_NSStreamSOCKSProxyPortKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSOCKSProxyPortKey, "NSStreamSOCKSProxyPortKey", nil);
}

// NSString * const NSStreamSOCKSProxyVersionKey;
static VALUE
osx_NSStreamSOCKSProxyVersionKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSOCKSProxyVersionKey, "NSStreamSOCKSProxyVersionKey", nil);
}

// NSString * const NSStreamSOCKSProxyUserKey;
static VALUE
osx_NSStreamSOCKSProxyUserKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSOCKSProxyUserKey, "NSStreamSOCKSProxyUserKey", nil);
}

// NSString * const NSStreamSOCKSProxyPasswordKey;
static VALUE
osx_NSStreamSOCKSProxyPasswordKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSOCKSProxyPasswordKey, "NSStreamSOCKSProxyPasswordKey", nil);
}

// NSString * const NSStreamSOCKSProxyVersion4;
static VALUE
osx_NSStreamSOCKSProxyVersion4(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSOCKSProxyVersion4, "NSStreamSOCKSProxyVersion4", nil);
}

// NSString * const NSStreamSOCKSProxyVersion5;
static VALUE
osx_NSStreamSOCKSProxyVersion5(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSOCKSProxyVersion5, "NSStreamSOCKSProxyVersion5", nil);
}

// NSString * const NSStreamDataWrittenToMemoryStreamKey;
static VALUE
osx_NSStreamDataWrittenToMemoryStreamKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamDataWrittenToMemoryStreamKey, "NSStreamDataWrittenToMemoryStreamKey", nil);
}

// NSString * const NSStreamFileCurrentOffsetKey;
static VALUE
osx_NSStreamFileCurrentOffsetKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamFileCurrentOffsetKey, "NSStreamFileCurrentOffsetKey", nil);
}

// NSString * const NSStreamSocketSSLErrorDomain;
static VALUE
osx_NSStreamSocketSSLErrorDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSocketSSLErrorDomain, "NSStreamSocketSSLErrorDomain", nil);
}

// NSString * const NSStreamSOCKSErrorDomain;
static VALUE
osx_NSStreamSOCKSErrorDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStreamSOCKSErrorDomain, "NSStreamSOCKSErrorDomain", nil);
}

void init_NSStream(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSStreamStatusNotOpen", INT2NUM(NSStreamStatusNotOpen));
  rb_define_const(mOSX, "NSStreamStatusOpening", INT2NUM(NSStreamStatusOpening));
  rb_define_const(mOSX, "NSStreamStatusOpen", INT2NUM(NSStreamStatusOpen));
  rb_define_const(mOSX, "NSStreamStatusReading", INT2NUM(NSStreamStatusReading));
  rb_define_const(mOSX, "NSStreamStatusWriting", INT2NUM(NSStreamStatusWriting));
  rb_define_const(mOSX, "NSStreamStatusAtEnd", INT2NUM(NSStreamStatusAtEnd));
  rb_define_const(mOSX, "NSStreamStatusClosed", INT2NUM(NSStreamStatusClosed));
  rb_define_const(mOSX, "NSStreamStatusError", INT2NUM(NSStreamStatusError));
  rb_define_const(mOSX, "NSStreamEventNone", INT2NUM(NSStreamEventNone));
  rb_define_const(mOSX, "NSStreamEventOpenCompleted", INT2NUM(NSStreamEventOpenCompleted));
  rb_define_const(mOSX, "NSStreamEventHasBytesAvailable", INT2NUM(NSStreamEventHasBytesAvailable));
  rb_define_const(mOSX, "NSStreamEventHasSpaceAvailable", INT2NUM(NSStreamEventHasSpaceAvailable));
  rb_define_const(mOSX, "NSStreamEventErrorOccurred", INT2NUM(NSStreamEventErrorOccurred));
  rb_define_const(mOSX, "NSStreamEventEndEncountered", INT2NUM(NSStreamEventEndEncountered));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSStreamSocketSecurityLevelKey", osx_NSStreamSocketSecurityLevelKey, 0);
  rb_define_module_function(mOSX, "NSStreamSocketSecurityLevelNone", osx_NSStreamSocketSecurityLevelNone, 0);
  rb_define_module_function(mOSX, "NSStreamSocketSecurityLevelSSLv2", osx_NSStreamSocketSecurityLevelSSLv2, 0);
  rb_define_module_function(mOSX, "NSStreamSocketSecurityLevelSSLv3", osx_NSStreamSocketSecurityLevelSSLv3, 0);
  rb_define_module_function(mOSX, "NSStreamSocketSecurityLevelTLSv1", osx_NSStreamSocketSecurityLevelTLSv1, 0);
  rb_define_module_function(mOSX, "NSStreamSocketSecurityLevelNegotiatedSSL", osx_NSStreamSocketSecurityLevelNegotiatedSSL, 0);
  rb_define_module_function(mOSX, "NSStreamSOCKSProxyConfigurationKey", osx_NSStreamSOCKSProxyConfigurationKey, 0);
  rb_define_module_function(mOSX, "NSStreamSOCKSProxyHostKey", osx_NSStreamSOCKSProxyHostKey, 0);
  rb_define_module_function(mOSX, "NSStreamSOCKSProxyPortKey", osx_NSStreamSOCKSProxyPortKey, 0);
  rb_define_module_function(mOSX, "NSStreamSOCKSProxyVersionKey", osx_NSStreamSOCKSProxyVersionKey, 0);
  rb_define_module_function(mOSX, "NSStreamSOCKSProxyUserKey", osx_NSStreamSOCKSProxyUserKey, 0);
  rb_define_module_function(mOSX, "NSStreamSOCKSProxyPasswordKey", osx_NSStreamSOCKSProxyPasswordKey, 0);
  rb_define_module_function(mOSX, "NSStreamSOCKSProxyVersion4", osx_NSStreamSOCKSProxyVersion4, 0);
  rb_define_module_function(mOSX, "NSStreamSOCKSProxyVersion5", osx_NSStreamSOCKSProxyVersion5, 0);
  rb_define_module_function(mOSX, "NSStreamDataWrittenToMemoryStreamKey", osx_NSStreamDataWrittenToMemoryStreamKey, 0);
  rb_define_module_function(mOSX, "NSStreamFileCurrentOffsetKey", osx_NSStreamFileCurrentOffsetKey, 0);
  rb_define_module_function(mOSX, "NSStreamSocketSSLErrorDomain", osx_NSStreamSocketSSLErrorDomain, 0);
  rb_define_module_function(mOSX, "NSStreamSOCKSErrorDomain", osx_NSStreamSOCKSErrorDomain, 0);
}
