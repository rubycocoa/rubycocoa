#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSFileType;
static VALUE
osx_NSFileType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileType, nil);
}

// NSString * const NSFileTypeDirectory;
static VALUE
osx_NSFileTypeDirectory(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeDirectory, nil);
}

// NSString * const NSFileTypeRegular;
static VALUE
osx_NSFileTypeRegular(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeRegular, nil);
}

// NSString * const NSFileTypeSymbolicLink;
static VALUE
osx_NSFileTypeSymbolicLink(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeSymbolicLink, nil);
}

// NSString * const NSFileTypeSocket;
static VALUE
osx_NSFileTypeSocket(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeSocket, nil);
}

// NSString * const NSFileTypeCharacterSpecial;
static VALUE
osx_NSFileTypeCharacterSpecial(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeCharacterSpecial, nil);
}

// NSString * const NSFileTypeBlockSpecial;
static VALUE
osx_NSFileTypeBlockSpecial(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeBlockSpecial, nil);
}

// NSString * const NSFileTypeUnknown;
static VALUE
osx_NSFileTypeUnknown(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileTypeUnknown, nil);
}

// NSString * const NSFileSize;
static VALUE
osx_NSFileSize(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSize, nil);
}

// NSString * const NSFileModificationDate;
static VALUE
osx_NSFileModificationDate(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileModificationDate, nil);
}

// NSString * const NSFileReferenceCount;
static VALUE
osx_NSFileReferenceCount(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileReferenceCount, nil);
}

// NSString * const NSFileDeviceIdentifier;
static VALUE
osx_NSFileDeviceIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileDeviceIdentifier, nil);
}

// NSString * const NSFileOwnerAccountName;
static VALUE
osx_NSFileOwnerAccountName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileOwnerAccountName, nil);
}

// NSString * const NSFileGroupOwnerAccountName;
static VALUE
osx_NSFileGroupOwnerAccountName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileGroupOwnerAccountName, nil);
}

// NSString * const NSFilePosixPermissions;
static VALUE
osx_NSFilePosixPermissions(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFilePosixPermissions, nil);
}

// NSString * const NSFileSystemNumber;
static VALUE
osx_NSFileSystemNumber(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemNumber, nil);
}

// NSString * const NSFileSystemFileNumber;
static VALUE
osx_NSFileSystemFileNumber(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemFileNumber, nil);
}

// NSString * const NSFileExtensionHidden;
static VALUE
osx_NSFileExtensionHidden(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileExtensionHidden, nil);
}

// NSString * const NSFileHFSCreatorCode;
static VALUE
osx_NSFileHFSCreatorCode(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileHFSCreatorCode, nil);
}

// NSString * const NSFileHFSTypeCode;
static VALUE
osx_NSFileHFSTypeCode(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileHFSTypeCode, nil);
}

// NSString * const NSFileImmutable;
static VALUE
osx_NSFileImmutable(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileImmutable, nil);
}

// NSString * const NSFileAppendOnly;
static VALUE
osx_NSFileAppendOnly(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileAppendOnly, nil);
}

// NSString * const NSFileCreationDate;
static VALUE
osx_NSFileCreationDate(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileCreationDate, nil);
}

// NSString * const NSFileOwnerAccountID;
static VALUE
osx_NSFileOwnerAccountID(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileOwnerAccountID, nil);
}

// NSString * const NSFileGroupOwnerAccountID;
static VALUE
osx_NSFileGroupOwnerAccountID(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileGroupOwnerAccountID, nil);
}

// NSString * const NSFileSystemSize;
static VALUE
osx_NSFileSystemSize(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemSize, nil);
}

// NSString * const NSFileSystemFreeSize;
static VALUE
osx_NSFileSystemFreeSize(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemFreeSize, nil);
}

// NSString * const NSFileSystemNodes;
static VALUE
osx_NSFileSystemNodes(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileSystemNodes, nil);
}

// NSString * const NSFileSystemFreeNodes;
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
  rb_define_module_function(mOSX, "NSFileImmutable", osx_NSFileImmutable, 0);
  rb_define_module_function(mOSX, "NSFileAppendOnly", osx_NSFileAppendOnly, 0);
  rb_define_module_function(mOSX, "NSFileCreationDate", osx_NSFileCreationDate, 0);
  rb_define_module_function(mOSX, "NSFileOwnerAccountID", osx_NSFileOwnerAccountID, 0);
  rb_define_module_function(mOSX, "NSFileGroupOwnerAccountID", osx_NSFileGroupOwnerAccountID, 0);
  rb_define_module_function(mOSX, "NSFileSystemSize", osx_NSFileSystemSize, 0);
  rb_define_module_function(mOSX, "NSFileSystemFreeSize", osx_NSFileSystemFreeSize, 0);
  rb_define_module_function(mOSX, "NSFileSystemNodes", osx_NSFileSystemNodes, 0);
  rb_define_module_function(mOSX, "NSFileSystemFreeNodes", osx_NSFileSystemFreeNodes, 0);
}
