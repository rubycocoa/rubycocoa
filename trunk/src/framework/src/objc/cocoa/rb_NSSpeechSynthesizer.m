#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSVoiceName;
static VALUE
osx_NSVoiceName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVoiceName, "NSVoiceName", nil);
}

// NSString * NSVoiceIdentifier;
static VALUE
osx_NSVoiceIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVoiceIdentifier, "NSVoiceIdentifier", nil);
}

// NSString * NSVoiceAge;
static VALUE
osx_NSVoiceAge(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVoiceAge, "NSVoiceAge", nil);
}

// NSString * NSVoiceGender;
static VALUE
osx_NSVoiceGender(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVoiceGender, "NSVoiceGender", nil);
}

// NSString * NSVoiceDemoText;
static VALUE
osx_NSVoiceDemoText(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVoiceDemoText, "NSVoiceDemoText", nil);
}

// NSString * NSVoiceLanguage;
static VALUE
osx_NSVoiceLanguage(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVoiceLanguage, "NSVoiceLanguage", nil);
}

// NSString * NSVoiceGenderNeuter;
static VALUE
osx_NSVoiceGenderNeuter(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVoiceGenderNeuter, "NSVoiceGenderNeuter", nil);
}

// NSString * NSVoiceGenderMale;
static VALUE
osx_NSVoiceGenderMale(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVoiceGenderMale, "NSVoiceGenderMale", nil);
}

// NSString * NSVoiceGenderFemale;
static VALUE
osx_NSVoiceGenderFemale(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVoiceGenderFemale, "NSVoiceGenderFemale", nil);
}

void init_NSSpeechSynthesizer(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSVoiceName", osx_NSVoiceName, 0);
  rb_define_module_function(mOSX, "NSVoiceIdentifier", osx_NSVoiceIdentifier, 0);
  rb_define_module_function(mOSX, "NSVoiceAge", osx_NSVoiceAge, 0);
  rb_define_module_function(mOSX, "NSVoiceGender", osx_NSVoiceGender, 0);
  rb_define_module_function(mOSX, "NSVoiceDemoText", osx_NSVoiceDemoText, 0);
  rb_define_module_function(mOSX, "NSVoiceLanguage", osx_NSVoiceLanguage, 0);
  rb_define_module_function(mOSX, "NSVoiceGenderNeuter", osx_NSVoiceGenderNeuter, 0);
  rb_define_module_function(mOSX, "NSVoiceGenderMale", osx_NSVoiceGenderMale, 0);
  rb_define_module_function(mOSX, "NSVoiceGenderFemale", osx_NSVoiceGenderFemale, 0);
}
