#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSNegateBooleanTransformerName;
static VALUE
osx_NSNegateBooleanTransformerName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNegateBooleanTransformerName, "NSNegateBooleanTransformerName", nil);
}

// NSString * const NSIsNilTransformerName;
static VALUE
osx_NSIsNilTransformerName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSIsNilTransformerName, "NSIsNilTransformerName", nil);
}

// NSString * const NSIsNotNilTransformerName;
static VALUE
osx_NSIsNotNilTransformerName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSIsNotNilTransformerName, "NSIsNotNilTransformerName", nil);
}

// NSString * const NSUnarchiveFromDataTransformerName;
static VALUE
osx_NSUnarchiveFromDataTransformerName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSUnarchiveFromDataTransformerName, "NSUnarchiveFromDataTransformerName", nil);
}

void init_NSValueTransformer(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSNegateBooleanTransformerName", osx_NSNegateBooleanTransformerName, 0);
  rb_define_module_function(mOSX, "NSIsNilTransformerName", osx_NSIsNilTransformerName, 0);
  rb_define_module_function(mOSX, "NSIsNotNilTransformerName", osx_NSIsNotNilTransformerName, 0);
  rb_define_module_function(mOSX, "NSUnarchiveFromDataTransformerName", osx_NSUnarchiveFromDataTransformerName, 0);
}
