#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSWorkspaceDidLaunchApplicationNotification;
static VALUE
osx_NSWorkspaceDidLaunchApplicationNotification(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceDidLaunchApplicationNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceDidMountNotification;
static VALUE
osx_NSWorkspaceDidMountNotification(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceDidMountNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceDidPerformFileOperationNotification;
static VALUE
osx_NSWorkspaceDidPerformFileOperationNotification(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceDidPerformFileOperationNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceDidTerminateApplicationNotification;
static VALUE
osx_NSWorkspaceDidTerminateApplicationNotification(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceDidTerminateApplicationNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceDidUnmountNotification;
static VALUE
osx_NSWorkspaceDidUnmountNotification(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceDidUnmountNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceWillLaunchApplicationNotification;
static VALUE
osx_NSWorkspaceWillLaunchApplicationNotification(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceWillLaunchApplicationNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceWillPowerOffNotification;
static VALUE
osx_NSWorkspaceWillPowerOffNotification(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceWillPowerOffNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceWillUnmountNotification;
static VALUE
osx_NSWorkspaceWillUnmountNotification(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceWillUnmountNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPlainFileType, *NSDirectoryFileType, *NSApplicationFileType;
static VALUE
osx_NSApplicationFileType(VALUE mdl)
{
  NSString *NSPlainFileType, *NSDirectoryFileType, * ns_result = NSApplicationFileType;
  return nsresult_to_rbresult(_C_PTR, &ns_result, nil);
}

// NSString *NSFilesystemFileType, *NSShellCommandFileType;
static VALUE
osx_NSShellCommandFileType(VALUE mdl)
{
  NSString *NSFilesystemFileType, * ns_result = NSShellCommandFileType;
  return nsresult_to_rbresult(_C_PTR, &ns_result, nil);
}

// NSString *NSWorkspaceMoveOperation;
static VALUE
osx_NSWorkspaceMoveOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceMoveOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceCopyOperation;
static VALUE
osx_NSWorkspaceCopyOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceCopyOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceLinkOperation;
static VALUE
osx_NSWorkspaceLinkOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceLinkOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceCompressOperation;
static VALUE
osx_NSWorkspaceCompressOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceCompressOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceDecompressOperation;
static VALUE
osx_NSWorkspaceDecompressOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceDecompressOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceEncryptOperation;
static VALUE
osx_NSWorkspaceEncryptOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceEncryptOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceDecryptOperation;
static VALUE
osx_NSWorkspaceDecryptOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceDecryptOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceDestroyOperation;
static VALUE
osx_NSWorkspaceDestroyOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceDestroyOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceRecycleOperation;
static VALUE
osx_NSWorkspaceRecycleOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceRecycleOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWorkspaceDuplicateOperation;
static VALUE
osx_NSWorkspaceDuplicateOperation(VALUE mdl)
{
  NSString * ns_result = NSWorkspaceDuplicateOperation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSWorkspace(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSWorkspaceDidLaunchApplicationNotification", osx_NSWorkspaceDidLaunchApplicationNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDidMountNotification", osx_NSWorkspaceDidMountNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDidPerformFileOperationNotification", osx_NSWorkspaceDidPerformFileOperationNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDidTerminateApplicationNotification", osx_NSWorkspaceDidTerminateApplicationNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDidUnmountNotification", osx_NSWorkspaceDidUnmountNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceWillLaunchApplicationNotification", osx_NSWorkspaceWillLaunchApplicationNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceWillPowerOffNotification", osx_NSWorkspaceWillPowerOffNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceWillUnmountNotification", osx_NSWorkspaceWillUnmountNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationFileType", osx_NSApplicationFileType, 0);
  rb_define_module_function(mOSX, "NSShellCommandFileType", osx_NSShellCommandFileType, 0);
  rb_define_module_function(mOSX, "NSWorkspaceMoveOperation", osx_NSWorkspaceMoveOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceCopyOperation", osx_NSWorkspaceCopyOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceLinkOperation", osx_NSWorkspaceLinkOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceCompressOperation", osx_NSWorkspaceCompressOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDecompressOperation", osx_NSWorkspaceDecompressOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceEncryptOperation", osx_NSWorkspaceEncryptOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDecryptOperation", osx_NSWorkspaceDecryptOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDestroyOperation", osx_NSWorkspaceDestroyOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceRecycleOperation", osx_NSWorkspaceRecycleOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDuplicateOperation", osx_NSWorkspaceDuplicateOperation, 0);
}
