#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

static void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", index);
  }
}

static VALUE
nsresult_to_rbresult(int octype, const void* nsresult, id pool)
{
  VALUE rbresult;
  if (octype == _C_ID) {
    rbresult = ocobj_new_with_ocid(*(id*)nsresult);
  }
  else {
    if (!ocdata_to_rbobj(octype, nsresult, &rbresult)) {
      if (pool) [pool release];
      rb_raise(rb_eRuntimeError, "result cannot convert to rbobj.");
    }
  }
  return rbresult;
}


  /**** constants ****/
// NSString * __const NSFileType;
static VALUE
osx_NSFileType(VALUE mdl)
{
  rb_notimplement();
}

// NSString 	* __const NSFileTypeDirectory;
static VALUE
osx_NSFileTypeDirectory(VALUE mdl)
{
  rb_notimplement();
}

// NSString 	* __const NSFileTypeRegular;
static VALUE
osx_NSFileTypeRegular(VALUE mdl)
{
  rb_notimplement();
}

// NSString 	* __const NSFileTypeSymbolicLink;
static VALUE
osx_NSFileTypeSymbolicLink(VALUE mdl)
{
  rb_notimplement();
}

// NSString 	* __const NSFileTypeSocket;
static VALUE
osx_NSFileTypeSocket(VALUE mdl)
{
  rb_notimplement();
}

// NSString 	* __const NSFileTypeCharacterSpecial;
static VALUE
osx_NSFileTypeCharacterSpecial(VALUE mdl)
{
  rb_notimplement();
}

// NSString 	* __const NSFileTypeBlockSpecial;
static VALUE
osx_NSFileTypeBlockSpecial(VALUE mdl)
{
  rb_notimplement();
}

// NSString 	* __const NSFileTypeUnknown;
static VALUE
osx_NSFileTypeUnknown(VALUE mdl)
{
  rb_notimplement();
}

// NSString	* __const NSFileSize;
static VALUE
osx_NSFileSize(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileModificationDate;
static VALUE
osx_NSFileModificationDate(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileReferenceCount;
static VALUE
osx_NSFileReferenceCount(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileDeviceIdentifier;
static VALUE
osx_NSFileDeviceIdentifier(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileOwnerAccountName;
static VALUE
osx_NSFileOwnerAccountName(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileGroupOwnerAccountName;
static VALUE
osx_NSFileGroupOwnerAccountName(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFilePosixPermissions;
static VALUE
osx_NSFilePosixPermissions(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileSystemNumber;
static VALUE
osx_NSFileSystemNumber(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileSystemFileNumber;
static VALUE
osx_NSFileSystemFileNumber(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileExtensionHidden;
static VALUE
osx_NSFileExtensionHidden(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileHFSCreatorCode;
static VALUE
osx_NSFileHFSCreatorCode(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileHFSTypeCode;
static VALUE
osx_NSFileHFSTypeCode(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileSystemSize;
static VALUE
osx_NSFileSystemSize(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileSystemFreeSize;
static VALUE
osx_NSFileSystemFreeSize(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileSystemNodes;
static VALUE
osx_NSFileSystemNodes(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSFileSystemFreeNodes;
static VALUE
osx_NSFileSystemFreeNodes(VALUE mdl)
{
  rb_notimplement();
}

void init_NSFileManager(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSFileType", osx_NSFileType, 0);
  rb_define_module_function(mOSX, "NSFileTypeDirectory", osx_NSFileTypeDirectory, 0);
  rb_define_module_function(mOSX, "NSFileTypeRegular", osx_NSFileTypeRegular, 0);
  rb_define_module_function(mOSX, "NSFileTypeSymbolicLink", osx_NSFileTypeSymbolicLink, 0);
  rb_define_module_function(mOSX, "NSFileTypeSocket", osx_NSFileTypeSocket, 0);
  rb_define_module_function(mOSX, "NSFileTypeCharacterSpecial", osx_NSFileTypeCharacterSpecial, 0);
  rb_define_module_function(mOSX, "NSFileTypeBlockSpecial", osx_NSFileTypeBlockSpecial, 0);
  rb_define_module_function(mOSX, "NSFileTypeUnknown", osx_NSFileTypeUnknown, 0);
  rb_define_module_function(mOSX, "NSFileSize", osx_NSFileSize, 0);
  rb_define_module_function(mOSX, "NSFileModificationDate", osx_NSFileModificationDate, 0);
  rb_define_module_function(mOSX, "NSFileReferenceCount", osx_NSFileReferenceCount, 0);
  rb_define_module_function(mOSX, "NSFileDeviceIdentifier", osx_NSFileDeviceIdentifier, 0);
  rb_define_module_function(mOSX, "NSFileOwnerAccountName", osx_NSFileOwnerAccountName, 0);
  rb_define_module_function(mOSX, "NSFileGroupOwnerAccountName", osx_NSFileGroupOwnerAccountName, 0);
  rb_define_module_function(mOSX, "NSFilePosixPermissions", osx_NSFilePosixPermissions, 0);
  rb_define_module_function(mOSX, "NSFileSystemNumber", osx_NSFileSystemNumber, 0);
  rb_define_module_function(mOSX, "NSFileSystemFileNumber", osx_NSFileSystemFileNumber, 0);
  rb_define_module_function(mOSX, "NSFileExtensionHidden", osx_NSFileExtensionHidden, 0);
  rb_define_module_function(mOSX, "NSFileHFSCreatorCode", osx_NSFileHFSCreatorCode, 0);
  rb_define_module_function(mOSX, "NSFileHFSTypeCode", osx_NSFileHFSTypeCode, 0);
  rb_define_module_function(mOSX, "NSFileSystemSize", osx_NSFileSystemSize, 0);
  rb_define_module_function(mOSX, "NSFileSystemFreeSize", osx_NSFileSystemFreeSize, 0);
  rb_define_module_function(mOSX, "NSFileSystemNodes", osx_NSFileSystemNodes, 0);
  rb_define_module_function(mOSX, "NSFileSystemFreeNodes", osx_NSFileSystemFreeNodes, 0);
}
