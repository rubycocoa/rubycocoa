#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * __const NSFileType;
static VALUE
osx_NSFileType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileType, nil);
}

// NSString 	* __const NSFileTypeDirectory;
static VALUE
osx_NSFileTypeDirectory(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeDirectory, nil);
}

// NSString 	* __const NSFileTypeRegular;
static VALUE
osx_NSFileTypeRegular(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeRegular, nil);
}

// NSString 	* __const NSFileTypeSymbolicLink;
static VALUE
osx_NSFileTypeSymbolicLink(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeSymbolicLink, nil);
}

// NSString 	* __const NSFileTypeSocket;
static VALUE
osx_NSFileTypeSocket(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeSocket, nil);
}

// NSString 	* __const NSFileTypeCharacterSpecial;
static VALUE
osx_NSFileTypeCharacterSpecial(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeCharacterSpecial, nil);
}

// NSString 	* __const NSFileTypeBlockSpecial;
static VALUE
osx_NSFileTypeBlockSpecial(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeBlockSpecial, nil);
}

// NSString 	* __const NSFileTypeUnknown;
static VALUE
osx_NSFileTypeUnknown(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeUnknown, nil);
}

// NSString	* __const NSFileSize;
static VALUE
osx_NSFileSize(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSize, nil);
}

// NSString * __const NSFileModificationDate;
static VALUE
osx_NSFileModificationDate(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileModificationDate, nil);
}

// NSString * __const NSFileReferenceCount;
static VALUE
osx_NSFileReferenceCount(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileReferenceCount, nil);
}

// NSString * __const NSFileDeviceIdentifier;
static VALUE
osx_NSFileDeviceIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileDeviceIdentifier, nil);
}

// NSString * __const NSFileOwnerAccountName;
static VALUE
osx_NSFileOwnerAccountName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileOwnerAccountName, nil);
}

// NSString * __const NSFileGroupOwnerAccountName;
static VALUE
osx_NSFileGroupOwnerAccountName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileGroupOwnerAccountName, nil);
}

// NSString * __const NSFilePosixPermissions;
static VALUE
osx_NSFilePosixPermissions(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFilePosixPermissions, nil);
}

// NSString * __const NSFileSystemNumber;
static VALUE
osx_NSFileSystemNumber(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemNumber, nil);
}

// NSString * __const NSFileSystemFileNumber;
static VALUE
osx_NSFileSystemFileNumber(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemFileNumber, nil);
}

// NSString * __const NSFileExtensionHidden;
static VALUE
osx_NSFileExtensionHidden(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileExtensionHidden, nil);
}

// NSString * __const NSFileHFSCreatorCode;
static VALUE
osx_NSFileHFSCreatorCode(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileHFSCreatorCode, nil);
}

// NSString * __const NSFileHFSTypeCode;
static VALUE
osx_NSFileHFSTypeCode(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileHFSTypeCode, nil);
}

// NSString * __const NSFileSystemSize;
static VALUE
osx_NSFileSystemSize(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemSize, nil);
}

// NSString * __const NSFileSystemFreeSize;
static VALUE
osx_NSFileSystemFreeSize(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemFreeSize, nil);
}

// NSString * __const NSFileSystemNodes;
static VALUE
osx_NSFileSystemNodes(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemNodes, nil);
}

// NSString * __const NSFileSystemFreeNodes;
static VALUE
osx_NSFileSystemFreeNodes(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemFreeNodes, nil);
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
