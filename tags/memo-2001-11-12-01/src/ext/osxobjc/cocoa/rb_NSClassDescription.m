#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSClassDescriptionNeededForClassNotification;
static VALUE
osx_NSClassDescriptionNeededForClassNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSClassDescriptionNeededForClassNotification, nil);
}

void init_NSClassDescription(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSClassDescriptionNeededForClassNotification", osx_NSClassDescriptionNeededForClassNotification, 0);
}
