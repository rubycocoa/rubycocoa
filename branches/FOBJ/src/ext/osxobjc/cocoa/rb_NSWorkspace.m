#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSWorkspaceDidLaunchApplicationNotification;
static VALUE
osx_NSWorkspaceDidLaunchApplicationNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceDidLaunchApplicationNotification);
}

// NSString *NSWorkspaceDidMountNotification;
static VALUE
osx_NSWorkspaceDidMountNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceDidMountNotification);
}

// NSString *NSWorkspaceDidPerformFileOperationNotification;
static VALUE
osx_NSWorkspaceDidPerformFileOperationNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceDidPerformFileOperationNotification);
}

// NSString *NSWorkspaceDidTerminateApplicationNotification;
static VALUE
osx_NSWorkspaceDidTerminateApplicationNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceDidTerminateApplicationNotification);
}

// NSString *NSWorkspaceDidUnmountNotification;
static VALUE
osx_NSWorkspaceDidUnmountNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceDidUnmountNotification);
}

// NSString *NSWorkspaceWillLaunchApplicationNotification;
static VALUE
osx_NSWorkspaceWillLaunchApplicationNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceWillLaunchApplicationNotification);
}

// NSString *NSWorkspaceWillPowerOffNotification;
static VALUE
osx_NSWorkspaceWillPowerOffNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceWillPowerOffNotification);
}

// NSString *NSWorkspaceWillUnmountNotification;
static VALUE
osx_NSWorkspaceWillUnmountNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceWillUnmountNotification);
}

// NSString *NSPlainFileType, *NSDirectoryFileType, *NSApplicationFileType;
static VALUE
osx_NSApplicationFileType(VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSFilesystemFileType, *NSShellCommandFileType;
static VALUE
osx_NSShellCommandFileType(VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSWorkspaceMoveOperation;
static VALUE
osx_NSWorkspaceMoveOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceMoveOperation);
}

// NSString *NSWorkspaceCopyOperation;
static VALUE
osx_NSWorkspaceCopyOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceCopyOperation);
}

// NSString *NSWorkspaceLinkOperation;
static VALUE
osx_NSWorkspaceLinkOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceLinkOperation);
}

// NSString *NSWorkspaceCompressOperation;
static VALUE
osx_NSWorkspaceCompressOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceCompressOperation);
}

// NSString *NSWorkspaceDecompressOperation;
static VALUE
osx_NSWorkspaceDecompressOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceDecompressOperation);
}

// NSString *NSWorkspaceEncryptOperation;
static VALUE
osx_NSWorkspaceEncryptOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceEncryptOperation);
}

// NSString *NSWorkspaceDecryptOperation;
static VALUE
osx_NSWorkspaceDecryptOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceDecryptOperation);
}

// NSString *NSWorkspaceDestroyOperation;
static VALUE
osx_NSWorkspaceDestroyOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceDestroyOperation);
}

// NSString *NSWorkspaceRecycleOperation;
static VALUE
osx_NSWorkspaceRecycleOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceRecycleOperation);
}

// NSString *NSWorkspaceDuplicateOperation;
static VALUE
osx_NSWorkspaceDuplicateOperation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWorkspaceDuplicateOperation);
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
