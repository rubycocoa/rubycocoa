#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSAccessibilityErrorCodeExceptionInfo;
static VALUE
osx_NSAccessibilityErrorCodeExceptionInfo(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityErrorCodeExceptionInfo, "NSAccessibilityErrorCodeExceptionInfo", nil);
}

// NSString * const NSAccessibilityRoleAttribute;
static VALUE
osx_NSAccessibilityRoleAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRoleAttribute, "NSAccessibilityRoleAttribute", nil);
}

// NSString * const NSAccessibilityRoleDescriptionAttribute;
static VALUE
osx_NSAccessibilityRoleDescriptionAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRoleDescriptionAttribute, "NSAccessibilityRoleDescriptionAttribute", nil);
}

// NSString * const NSAccessibilitySubroleAttribute;
static VALUE
osx_NSAccessibilitySubroleAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySubroleAttribute, "NSAccessibilitySubroleAttribute", nil);
}

// NSString * const NSAccessibilityHelpAttribute;
static VALUE
osx_NSAccessibilityHelpAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityHelpAttribute, "NSAccessibilityHelpAttribute", nil);
}

// NSString * const NSAccessibilityTitleAttribute;
static VALUE
osx_NSAccessibilityTitleAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityTitleAttribute, "NSAccessibilityTitleAttribute", nil);
}

// NSString * const NSAccessibilityValueAttribute;
static VALUE
osx_NSAccessibilityValueAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityValueAttribute, "NSAccessibilityValueAttribute", nil);
}

// NSString * const NSAccessibilityMinValueAttribute;
static VALUE
osx_NSAccessibilityMinValueAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMinValueAttribute, "NSAccessibilityMinValueAttribute", nil);
}

// NSString * const NSAccessibilityMaxValueAttribute;
static VALUE
osx_NSAccessibilityMaxValueAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMaxValueAttribute, "NSAccessibilityMaxValueAttribute", nil);
}

// NSString * const NSAccessibilityEnabledAttribute;
static VALUE
osx_NSAccessibilityEnabledAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityEnabledAttribute, "NSAccessibilityEnabledAttribute", nil);
}

// NSString * const NSAccessibilityFocusedAttribute;
static VALUE
osx_NSAccessibilityFocusedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityFocusedAttribute, "NSAccessibilityFocusedAttribute", nil);
}

// NSString * const NSAccessibilityParentAttribute;
static VALUE
osx_NSAccessibilityParentAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityParentAttribute, "NSAccessibilityParentAttribute", nil);
}

// NSString * const NSAccessibilityChildrenAttribute;
static VALUE
osx_NSAccessibilityChildrenAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityChildrenAttribute, "NSAccessibilityChildrenAttribute", nil);
}

// NSString * const NSAccessibilityWindowAttribute;
static VALUE
osx_NSAccessibilityWindowAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityWindowAttribute, "NSAccessibilityWindowAttribute", nil);
}

// NSString * const NSAccessibilitySelectedChildrenAttribute;
static VALUE
osx_NSAccessibilitySelectedChildrenAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySelectedChildrenAttribute, "NSAccessibilitySelectedChildrenAttribute", nil);
}

// NSString * const NSAccessibilityVisibleChildrenAttribute;
static VALUE
osx_NSAccessibilityVisibleChildrenAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityVisibleChildrenAttribute, "NSAccessibilityVisibleChildrenAttribute", nil);
}

// NSString * const NSAccessibilityPositionAttribute;
static VALUE
osx_NSAccessibilityPositionAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityPositionAttribute, "NSAccessibilityPositionAttribute", nil);
}

// NSString * const NSAccessibilitySizeAttribute;
static VALUE
osx_NSAccessibilitySizeAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySizeAttribute, "NSAccessibilitySizeAttribute", nil);
}

// NSString * const NSAccessibilityContentsAttribute;
static VALUE
osx_NSAccessibilityContentsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityContentsAttribute, "NSAccessibilityContentsAttribute", nil);
}

// NSString * const NSAccessibilityPreviousContentsAttribute;
static VALUE
osx_NSAccessibilityPreviousContentsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityPreviousContentsAttribute, "NSAccessibilityPreviousContentsAttribute", nil);
}

// NSString * const NSAccessibilityNextContentsAttribute;
static VALUE
osx_NSAccessibilityNextContentsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityNextContentsAttribute, "NSAccessibilityNextContentsAttribute", nil);
}

// NSString * const NSAccessibilitySelectedTextAttribute;
static VALUE
osx_NSAccessibilitySelectedTextAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySelectedTextAttribute, "NSAccessibilitySelectedTextAttribute", nil);
}

// NSString * const NSAccessibilitySelectedTextRangeAttribute;
static VALUE
osx_NSAccessibilitySelectedTextRangeAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySelectedTextRangeAttribute, "NSAccessibilitySelectedTextRangeAttribute", nil);
}

// NSString * const NSAccessibilityNumberOfCharactersAttribute;
static VALUE
osx_NSAccessibilityNumberOfCharactersAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityNumberOfCharactersAttribute, "NSAccessibilityNumberOfCharactersAttribute", nil);
}

// NSString * const NSAccessibilityVisibleCharacterRangeAttribute;
static VALUE
osx_NSAccessibilityVisibleCharacterRangeAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityVisibleCharacterRangeAttribute, "NSAccessibilityVisibleCharacterRangeAttribute", nil);
}

// NSString * const NSAccessibilityLineForIndexParameterizedAttribute;
static VALUE
osx_NSAccessibilityLineForIndexParameterizedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityLineForIndexParameterizedAttribute, "NSAccessibilityLineForIndexParameterizedAttribute", nil);
}

// NSString * const NSAccessibilityRangeForLineParameterizedAttribute;
static VALUE
osx_NSAccessibilityRangeForLineParameterizedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRangeForLineParameterizedAttribute, "NSAccessibilityRangeForLineParameterizedAttribute", nil);
}

// NSString * const NSAccessibilityStringForRangeParameterizedAttribute;
static VALUE
osx_NSAccessibilityStringForRangeParameterizedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityStringForRangeParameterizedAttribute, "NSAccessibilityStringForRangeParameterizedAttribute", nil);
}

// NSString * const NSAccessibilityRangeForPositionParameterizedAttribute;
static VALUE
osx_NSAccessibilityRangeForPositionParameterizedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRangeForPositionParameterizedAttribute, "NSAccessibilityRangeForPositionParameterizedAttribute", nil);
}

// NSString * const NSAccessibilityRangeForIndexParameterizedAttribute;
static VALUE
osx_NSAccessibilityRangeForIndexParameterizedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRangeForIndexParameterizedAttribute, "NSAccessibilityRangeForIndexParameterizedAttribute", nil);
}

// NSString * const NSAccessibilityBoundsForRangeParameterizedAttribute;
static VALUE
osx_NSAccessibilityBoundsForRangeParameterizedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityBoundsForRangeParameterizedAttribute, "NSAccessibilityBoundsForRangeParameterizedAttribute", nil);
}

// NSString * const NSAccessibilityRTFForRangeParameterizedAttribute;
static VALUE
osx_NSAccessibilityRTFForRangeParameterizedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRTFForRangeParameterizedAttribute, "NSAccessibilityRTFForRangeParameterizedAttribute", nil);
}

// NSString * const NSAccessibilityStyleRangeForIndexParameterizedAttribute;
static VALUE
osx_NSAccessibilityStyleRangeForIndexParameterizedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityStyleRangeForIndexParameterizedAttribute, "NSAccessibilityStyleRangeForIndexParameterizedAttribute", nil);
}

// NSString * const NSAccessibilityMainAttribute;
static VALUE
osx_NSAccessibilityMainAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMainAttribute, "NSAccessibilityMainAttribute", nil);
}

// NSString * const NSAccessibilityMinimizedAttribute;
static VALUE
osx_NSAccessibilityMinimizedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMinimizedAttribute, "NSAccessibilityMinimizedAttribute", nil);
}

// NSString * const NSAccessibilityCloseButtonAttribute;
static VALUE
osx_NSAccessibilityCloseButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityCloseButtonAttribute, "NSAccessibilityCloseButtonAttribute", nil);
}

// NSString * const NSAccessibilityZoomButtonAttribute;
static VALUE
osx_NSAccessibilityZoomButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityZoomButtonAttribute, "NSAccessibilityZoomButtonAttribute", nil);
}

// NSString * const NSAccessibilityMinimizeButtonAttribute;
static VALUE
osx_NSAccessibilityMinimizeButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMinimizeButtonAttribute, "NSAccessibilityMinimizeButtonAttribute", nil);
}

// NSString * const NSAccessibilityToolbarButtonAttribute;
static VALUE
osx_NSAccessibilityToolbarButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityToolbarButtonAttribute, "NSAccessibilityToolbarButtonAttribute", nil);
}

// NSString * const NSAccessibilityProxyAttribute;
static VALUE
osx_NSAccessibilityProxyAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityProxyAttribute, "NSAccessibilityProxyAttribute", nil);
}

// NSString * const NSAccessibilityGrowAreaAttribute;
static VALUE
osx_NSAccessibilityGrowAreaAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityGrowAreaAttribute, "NSAccessibilityGrowAreaAttribute", nil);
}

// NSString * const NSAccessibilityModalAttribute;
static VALUE
osx_NSAccessibilityModalAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityModalAttribute, "NSAccessibilityModalAttribute", nil);
}

// NSString * const NSAccessibilityDefaultButtonAttribute;
static VALUE
osx_NSAccessibilityDefaultButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDefaultButtonAttribute, "NSAccessibilityDefaultButtonAttribute", nil);
}

// NSString * const NSAccessibilityCancelButtonAttribute;
static VALUE
osx_NSAccessibilityCancelButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityCancelButtonAttribute, "NSAccessibilityCancelButtonAttribute", nil);
}

// NSString * const NSAccessibilityMenuBarAttribute;
static VALUE
osx_NSAccessibilityMenuBarAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMenuBarAttribute, "NSAccessibilityMenuBarAttribute", nil);
}

// NSString * const NSAccessibilityWindowsAttribute;
static VALUE
osx_NSAccessibilityWindowsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityWindowsAttribute, "NSAccessibilityWindowsAttribute", nil);
}

// NSString * const NSAccessibilityFrontmostAttribute;
static VALUE
osx_NSAccessibilityFrontmostAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityFrontmostAttribute, "NSAccessibilityFrontmostAttribute", nil);
}

// NSString * const NSAccessibilityHiddenAttribute;
static VALUE
osx_NSAccessibilityHiddenAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityHiddenAttribute, "NSAccessibilityHiddenAttribute", nil);
}

// NSString * const NSAccessibilityMainWindowAttribute;
static VALUE
osx_NSAccessibilityMainWindowAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMainWindowAttribute, "NSAccessibilityMainWindowAttribute", nil);
}

// NSString * const NSAccessibilityFocusedWindowAttribute;
static VALUE
osx_NSAccessibilityFocusedWindowAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityFocusedWindowAttribute, "NSAccessibilityFocusedWindowAttribute", nil);
}

// NSString * const NSAccessibilityFocusedUIElementAttribute;
static VALUE
osx_NSAccessibilityFocusedUIElementAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityFocusedUIElementAttribute, "NSAccessibilityFocusedUIElementAttribute", nil);
}

// NSString * const NSAccessibilityHeaderAttribute;
static VALUE
osx_NSAccessibilityHeaderAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityHeaderAttribute, "NSAccessibilityHeaderAttribute", nil);
}

// NSString * const NSAccessibilityEditedAttribute;
static VALUE
osx_NSAccessibilityEditedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityEditedAttribute, "NSAccessibilityEditedAttribute", nil);
}

// NSString * const NSAccessibilityTabsAttribute;
static VALUE
osx_NSAccessibilityTabsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityTabsAttribute, "NSAccessibilityTabsAttribute", nil);
}

// NSString * const NSAccessibilityTitleUIElementAttribute;
static VALUE
osx_NSAccessibilityTitleUIElementAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityTitleUIElementAttribute, "NSAccessibilityTitleUIElementAttribute", nil);
}

// NSString * const NSAccessibilityHorizontalScrollBarAttribute;
static VALUE
osx_NSAccessibilityHorizontalScrollBarAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityHorizontalScrollBarAttribute, "NSAccessibilityHorizontalScrollBarAttribute", nil);
}

// NSString * const NSAccessibilityVerticalScrollBarAttribute;
static VALUE
osx_NSAccessibilityVerticalScrollBarAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityVerticalScrollBarAttribute, "NSAccessibilityVerticalScrollBarAttribute", nil);
}

// NSString * const NSAccessibilityOverflowButtonAttribute;
static VALUE
osx_NSAccessibilityOverflowButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityOverflowButtonAttribute, "NSAccessibilityOverflowButtonAttribute", nil);
}

// NSString * const NSAccessibilityIncrementButtonAttribute;
static VALUE
osx_NSAccessibilityIncrementButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityIncrementButtonAttribute, "NSAccessibilityIncrementButtonAttribute", nil);
}

// NSString * const NSAccessibilityDecrementButtonAttribute;
static VALUE
osx_NSAccessibilityDecrementButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDecrementButtonAttribute, "NSAccessibilityDecrementButtonAttribute", nil);
}

// NSString * const NSAccessibilityFilenameAttribute;
static VALUE
osx_NSAccessibilityFilenameAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityFilenameAttribute, "NSAccessibilityFilenameAttribute", nil);
}

// NSString * const NSAccessibilityExpandedAttribute;
static VALUE
osx_NSAccessibilityExpandedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityExpandedAttribute, "NSAccessibilityExpandedAttribute", nil);
}

// NSString * const NSAccessibilitySelectedAttribute;
static VALUE
osx_NSAccessibilitySelectedAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySelectedAttribute, "NSAccessibilitySelectedAttribute", nil);
}

// NSString * const NSAccessibilitySplittersAttribute;
static VALUE
osx_NSAccessibilitySplittersAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySplittersAttribute, "NSAccessibilitySplittersAttribute", nil);
}

// NSString * const NSAccessibilityDocumentAttribute;
static VALUE
osx_NSAccessibilityDocumentAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDocumentAttribute, "NSAccessibilityDocumentAttribute", nil);
}

// NSString * const NSAccessibilityOrientationAttribute;
static VALUE
osx_NSAccessibilityOrientationAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityOrientationAttribute, "NSAccessibilityOrientationAttribute", nil);
}

// NSString * const NSAccessibilityVerticalOrientationValue;
static VALUE
osx_NSAccessibilityVerticalOrientationValue(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityVerticalOrientationValue, "NSAccessibilityVerticalOrientationValue", nil);
}

// NSString * const NSAccessibilityHorizontalOrientationValue;
static VALUE
osx_NSAccessibilityHorizontalOrientationValue(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityHorizontalOrientationValue, "NSAccessibilityHorizontalOrientationValue", nil);
}

// NSString * const NSAccessibilityColumnTitlesAttribute;
static VALUE
osx_NSAccessibilityColumnTitlesAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityColumnTitlesAttribute, "NSAccessibilityColumnTitlesAttribute", nil);
}

// NSString * const NSAccessibilitySearchButtonAttribute;
static VALUE
osx_NSAccessibilitySearchButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySearchButtonAttribute, "NSAccessibilitySearchButtonAttribute", nil);
}

// NSString * const NSAccessibilitySearchMenuAttribute;
static VALUE
osx_NSAccessibilitySearchMenuAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySearchMenuAttribute, "NSAccessibilitySearchMenuAttribute", nil);
}

// NSString * const NSAccessibilityClearButtonAttribute;
static VALUE
osx_NSAccessibilityClearButtonAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityClearButtonAttribute, "NSAccessibilityClearButtonAttribute", nil);
}

// NSString * const NSAccessibilityRowsAttribute;
static VALUE
osx_NSAccessibilityRowsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRowsAttribute, "NSAccessibilityRowsAttribute", nil);
}

// NSString * const NSAccessibilityVisibleRowsAttribute;
static VALUE
osx_NSAccessibilityVisibleRowsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityVisibleRowsAttribute, "NSAccessibilityVisibleRowsAttribute", nil);
}

// NSString * const NSAccessibilitySelectedRowsAttribute;
static VALUE
osx_NSAccessibilitySelectedRowsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySelectedRowsAttribute, "NSAccessibilitySelectedRowsAttribute", nil);
}

// NSString * const NSAccessibilityColumnsAttribute;
static VALUE
osx_NSAccessibilityColumnsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityColumnsAttribute, "NSAccessibilityColumnsAttribute", nil);
}

// NSString * const NSAccessibilityVisibleColumnsAttribute;
static VALUE
osx_NSAccessibilityVisibleColumnsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityVisibleColumnsAttribute, "NSAccessibilityVisibleColumnsAttribute", nil);
}

// NSString * const NSAccessibilitySelectedColumnsAttribute;
static VALUE
osx_NSAccessibilitySelectedColumnsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySelectedColumnsAttribute, "NSAccessibilitySelectedColumnsAttribute", nil);
}

// NSString * const NSAccessibilitySortDirectionAttribute;
static VALUE
osx_NSAccessibilitySortDirectionAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySortDirectionAttribute, "NSAccessibilitySortDirectionAttribute", nil);
}

// NSString * const NSAccessibilityDisclosingAttribute;
static VALUE
osx_NSAccessibilityDisclosingAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDisclosingAttribute, "NSAccessibilityDisclosingAttribute", nil);
}

// NSString * const NSAccessibilityDisclosedRowsAttribute;
static VALUE
osx_NSAccessibilityDisclosedRowsAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDisclosedRowsAttribute, "NSAccessibilityDisclosedRowsAttribute", nil);
}

// NSString * const NSAccessibilityDisclosedByRowAttribute;
static VALUE
osx_NSAccessibilityDisclosedByRowAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDisclosedByRowAttribute, "NSAccessibilityDisclosedByRowAttribute", nil);
}

// NSString * const NSAccessibilityPressAction;
static VALUE
osx_NSAccessibilityPressAction(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityPressAction, "NSAccessibilityPressAction", nil);
}

// NSString * const NSAccessibilityIncrementAction;
static VALUE
osx_NSAccessibilityIncrementAction(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityIncrementAction, "NSAccessibilityIncrementAction", nil);
}

// NSString * const NSAccessibilityDecrementAction;
static VALUE
osx_NSAccessibilityDecrementAction(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDecrementAction, "NSAccessibilityDecrementAction", nil);
}

// NSString * const NSAccessibilityConfirmAction;
static VALUE
osx_NSAccessibilityConfirmAction(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityConfirmAction, "NSAccessibilityConfirmAction", nil);
}

// NSString * const NSAccessibilityPickAction;
static VALUE
osx_NSAccessibilityPickAction(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityPickAction, "NSAccessibilityPickAction", nil);
}

// NSString * const NSAccessibilityCancelAction;
static VALUE
osx_NSAccessibilityCancelAction(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityCancelAction, "NSAccessibilityCancelAction", nil);
}

// NSString * const NSAccessibilityRaiseAction;
static VALUE
osx_NSAccessibilityRaiseAction(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRaiseAction, "NSAccessibilityRaiseAction", nil);
}

// NSString * const NSAccessibilityMainWindowChangedNotification;
static VALUE
osx_NSAccessibilityMainWindowChangedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMainWindowChangedNotification, "NSAccessibilityMainWindowChangedNotification", nil);
}

// NSString * const NSAccessibilityFocusedWindowChangedNotification;
static VALUE
osx_NSAccessibilityFocusedWindowChangedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityFocusedWindowChangedNotification, "NSAccessibilityFocusedWindowChangedNotification", nil);
}

// NSString * const NSAccessibilityFocusedUIElementChangedNotification;
static VALUE
osx_NSAccessibilityFocusedUIElementChangedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityFocusedUIElementChangedNotification, "NSAccessibilityFocusedUIElementChangedNotification", nil);
}

// NSString * const NSAccessibilityApplicationActivatedNotification;
static VALUE
osx_NSAccessibilityApplicationActivatedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityApplicationActivatedNotification, "NSAccessibilityApplicationActivatedNotification", nil);
}

// NSString * const NSAccessibilityApplicationDeactivatedNotification;
static VALUE
osx_NSAccessibilityApplicationDeactivatedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityApplicationDeactivatedNotification, "NSAccessibilityApplicationDeactivatedNotification", nil);
}

// NSString * const NSAccessibilityApplicationHiddenNotification;
static VALUE
osx_NSAccessibilityApplicationHiddenNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityApplicationHiddenNotification, "NSAccessibilityApplicationHiddenNotification", nil);
}

// NSString * const NSAccessibilityApplicationShownNotification;
static VALUE
osx_NSAccessibilityApplicationShownNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityApplicationShownNotification, "NSAccessibilityApplicationShownNotification", nil);
}

// NSString * const NSAccessibilityWindowCreatedNotification;
static VALUE
osx_NSAccessibilityWindowCreatedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityWindowCreatedNotification, "NSAccessibilityWindowCreatedNotification", nil);
}

// NSString * const NSAccessibilityWindowMovedNotification;
static VALUE
osx_NSAccessibilityWindowMovedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityWindowMovedNotification, "NSAccessibilityWindowMovedNotification", nil);
}

// NSString * const NSAccessibilityWindowResizedNotification;
static VALUE
osx_NSAccessibilityWindowResizedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityWindowResizedNotification, "NSAccessibilityWindowResizedNotification", nil);
}

// NSString * const NSAccessibilityWindowMiniaturizedNotification;
static VALUE
osx_NSAccessibilityWindowMiniaturizedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityWindowMiniaturizedNotification, "NSAccessibilityWindowMiniaturizedNotification", nil);
}

// NSString * const NSAccessibilityWindowDeminiaturizedNotification;
static VALUE
osx_NSAccessibilityWindowDeminiaturizedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityWindowDeminiaturizedNotification, "NSAccessibilityWindowDeminiaturizedNotification", nil);
}

// NSString * const NSAccessibilityDrawerCreatedNotification;
static VALUE
osx_NSAccessibilityDrawerCreatedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDrawerCreatedNotification, "NSAccessibilityDrawerCreatedNotification", nil);
}

// NSString * const NSAccessibilitySheetCreatedNotification;
static VALUE
osx_NSAccessibilitySheetCreatedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySheetCreatedNotification, "NSAccessibilitySheetCreatedNotification", nil);
}

// NSString * const NSAccessibilityValueChangedNotification;
static VALUE
osx_NSAccessibilityValueChangedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityValueChangedNotification, "NSAccessibilityValueChangedNotification", nil);
}

// NSString * const NSAccessibilityUIElementDestroyedNotification;
static VALUE
osx_NSAccessibilityUIElementDestroyedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityUIElementDestroyedNotification, "NSAccessibilityUIElementDestroyedNotification", nil);
}

// NSString * const NSAccessibilityUnknownRole;
static VALUE
osx_NSAccessibilityUnknownRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityUnknownRole, "NSAccessibilityUnknownRole", nil);
}

// NSString * const NSAccessibilityButtonRole;
static VALUE
osx_NSAccessibilityButtonRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityButtonRole, "NSAccessibilityButtonRole", nil);
}

// NSString * const NSAccessibilityRadioButtonRole;
static VALUE
osx_NSAccessibilityRadioButtonRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRadioButtonRole, "NSAccessibilityRadioButtonRole", nil);
}

// NSString * const NSAccessibilityCheckBoxRole;
static VALUE
osx_NSAccessibilityCheckBoxRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityCheckBoxRole, "NSAccessibilityCheckBoxRole", nil);
}

// NSString * const NSAccessibilitySliderRole;
static VALUE
osx_NSAccessibilitySliderRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySliderRole, "NSAccessibilitySliderRole", nil);
}

// NSString * const NSAccessibilityTabGroupRole;
static VALUE
osx_NSAccessibilityTabGroupRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityTabGroupRole, "NSAccessibilityTabGroupRole", nil);
}

// NSString * const NSAccessibilityTextFieldRole;
static VALUE
osx_NSAccessibilityTextFieldRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityTextFieldRole, "NSAccessibilityTextFieldRole", nil);
}

// NSString * const NSAccessibilityStaticTextRole;
static VALUE
osx_NSAccessibilityStaticTextRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityStaticTextRole, "NSAccessibilityStaticTextRole", nil);
}

// NSString * const NSAccessibilityTextAreaRole;
static VALUE
osx_NSAccessibilityTextAreaRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityTextAreaRole, "NSAccessibilityTextAreaRole", nil);
}

// NSString * const NSAccessibilityScrollAreaRole;
static VALUE
osx_NSAccessibilityScrollAreaRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityScrollAreaRole, "NSAccessibilityScrollAreaRole", nil);
}

// NSString * const NSAccessibilityPopUpButtonRole;
static VALUE
osx_NSAccessibilityPopUpButtonRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityPopUpButtonRole, "NSAccessibilityPopUpButtonRole", nil);
}

// NSString * const NSAccessibilityMenuButtonRole;
static VALUE
osx_NSAccessibilityMenuButtonRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMenuButtonRole, "NSAccessibilityMenuButtonRole", nil);
}

// NSString * const NSAccessibilityTableRole;
static VALUE
osx_NSAccessibilityTableRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityTableRole, "NSAccessibilityTableRole", nil);
}

// NSString * const NSAccessibilityApplicationRole;
static VALUE
osx_NSAccessibilityApplicationRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityApplicationRole, "NSAccessibilityApplicationRole", nil);
}

// NSString * const NSAccessibilityGroupRole;
static VALUE
osx_NSAccessibilityGroupRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityGroupRole, "NSAccessibilityGroupRole", nil);
}

// NSString * const NSAccessibilityRadioGroupRole;
static VALUE
osx_NSAccessibilityRadioGroupRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRadioGroupRole, "NSAccessibilityRadioGroupRole", nil);
}

// NSString * const NSAccessibilityListRole;
static VALUE
osx_NSAccessibilityListRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityListRole, "NSAccessibilityListRole", nil);
}

// NSString * const NSAccessibilityScrollBarRole;
static VALUE
osx_NSAccessibilityScrollBarRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityScrollBarRole, "NSAccessibilityScrollBarRole", nil);
}

// NSString * const NSAccessibilityValueIndicatorRole;
static VALUE
osx_NSAccessibilityValueIndicatorRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityValueIndicatorRole, "NSAccessibilityValueIndicatorRole", nil);
}

// NSString * const NSAccessibilityImageRole;
static VALUE
osx_NSAccessibilityImageRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityImageRole, "NSAccessibilityImageRole", nil);
}

// NSString * const NSAccessibilityMenuBarRole;
static VALUE
osx_NSAccessibilityMenuBarRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMenuBarRole, "NSAccessibilityMenuBarRole", nil);
}

// NSString * const NSAccessibilityMenuRole;
static VALUE
osx_NSAccessibilityMenuRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMenuRole, "NSAccessibilityMenuRole", nil);
}

// NSString * const NSAccessibilityMenuItemRole;
static VALUE
osx_NSAccessibilityMenuItemRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMenuItemRole, "NSAccessibilityMenuItemRole", nil);
}

// NSString * const NSAccessibilityColumnRole;
static VALUE
osx_NSAccessibilityColumnRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityColumnRole, "NSAccessibilityColumnRole", nil);
}

// NSString * const NSAccessibilityRowRole;
static VALUE
osx_NSAccessibilityRowRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityRowRole, "NSAccessibilityRowRole", nil);
}

// NSString * const NSAccessibilityToolbarRole;
static VALUE
osx_NSAccessibilityToolbarRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityToolbarRole, "NSAccessibilityToolbarRole", nil);
}

// NSString * const NSAccessibilityBusyIndicatorRole;
static VALUE
osx_NSAccessibilityBusyIndicatorRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityBusyIndicatorRole, "NSAccessibilityBusyIndicatorRole", nil);
}

// NSString * const NSAccessibilityProgressIndicatorRole;
static VALUE
osx_NSAccessibilityProgressIndicatorRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityProgressIndicatorRole, "NSAccessibilityProgressIndicatorRole", nil);
}

// NSString * const NSAccessibilityWindowRole;
static VALUE
osx_NSAccessibilityWindowRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityWindowRole, "NSAccessibilityWindowRole", nil);
}

// NSString * const NSAccessibilityDrawerRole;
static VALUE
osx_NSAccessibilityDrawerRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDrawerRole, "NSAccessibilityDrawerRole", nil);
}

// NSString * const NSAccessibilitySystemWideRole;
static VALUE
osx_NSAccessibilitySystemWideRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySystemWideRole, "NSAccessibilitySystemWideRole", nil);
}

// NSString * const NSAccessibilityOutlineRole;
static VALUE
osx_NSAccessibilityOutlineRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityOutlineRole, "NSAccessibilityOutlineRole", nil);
}

// NSString * const NSAccessibilityIncrementorRole;
static VALUE
osx_NSAccessibilityIncrementorRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityIncrementorRole, "NSAccessibilityIncrementorRole", nil);
}

// NSString * const NSAccessibilityBrowserRole;
static VALUE
osx_NSAccessibilityBrowserRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityBrowserRole, "NSAccessibilityBrowserRole", nil);
}

// NSString * const NSAccessibilityComboBoxRole;
static VALUE
osx_NSAccessibilityComboBoxRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityComboBoxRole, "NSAccessibilityComboBoxRole", nil);
}

// NSString * const NSAccessibilitySplitGroupRole;
static VALUE
osx_NSAccessibilitySplitGroupRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySplitGroupRole, "NSAccessibilitySplitGroupRole", nil);
}

// NSString * const NSAccessibilitySplitterRole;
static VALUE
osx_NSAccessibilitySplitterRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySplitterRole, "NSAccessibilitySplitterRole", nil);
}

// NSString * const NSAccessibilityColorWellRole;
static VALUE
osx_NSAccessibilityColorWellRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityColorWellRole, "NSAccessibilityColorWellRole", nil);
}

// NSString * const NSAccessibilityGrowAreaRole;
static VALUE
osx_NSAccessibilityGrowAreaRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityGrowAreaRole, "NSAccessibilityGrowAreaRole", nil);
}

// NSString * const NSAccessibilitySheetRole;
static VALUE
osx_NSAccessibilitySheetRole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySheetRole, "NSAccessibilitySheetRole", nil);
}

// NSString * const NSAccessibilityUnknownSubrole;
static VALUE
osx_NSAccessibilityUnknownSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityUnknownSubrole, "NSAccessibilityUnknownSubrole", nil);
}

// NSString * const NSAccessibilityCloseButtonSubrole;
static VALUE
osx_NSAccessibilityCloseButtonSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityCloseButtonSubrole, "NSAccessibilityCloseButtonSubrole", nil);
}

// NSString * const NSAccessibilityZoomButtonSubrole;
static VALUE
osx_NSAccessibilityZoomButtonSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityZoomButtonSubrole, "NSAccessibilityZoomButtonSubrole", nil);
}

// NSString * const NSAccessibilityMinimizeButtonSubrole;
static VALUE
osx_NSAccessibilityMinimizeButtonSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityMinimizeButtonSubrole, "NSAccessibilityMinimizeButtonSubrole", nil);
}

// NSString * const NSAccessibilityToolbarButtonSubrole;
static VALUE
osx_NSAccessibilityToolbarButtonSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityToolbarButtonSubrole, "NSAccessibilityToolbarButtonSubrole", nil);
}

// NSString * const NSAccessibilityTableRowSubrole;
static VALUE
osx_NSAccessibilityTableRowSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityTableRowSubrole, "NSAccessibilityTableRowSubrole", nil);
}

// NSString * const NSAccessibilityOutlineRowSubrole;
static VALUE
osx_NSAccessibilityOutlineRowSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityOutlineRowSubrole, "NSAccessibilityOutlineRowSubrole", nil);
}

// NSString * const NSAccessibilitySecureTextFieldSubrole;
static VALUE
osx_NSAccessibilitySecureTextFieldSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySecureTextFieldSubrole, "NSAccessibilitySecureTextFieldSubrole", nil);
}

// NSString * const NSAccessibilityStandardWindowSubrole;
static VALUE
osx_NSAccessibilityStandardWindowSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityStandardWindowSubrole, "NSAccessibilityStandardWindowSubrole", nil);
}

// NSString * const NSAccessibilityDialogSubrole;
static VALUE
osx_NSAccessibilityDialogSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDialogSubrole, "NSAccessibilityDialogSubrole", nil);
}

// NSString * const NSAccessibilitySystemDialogSubrole;
static VALUE
osx_NSAccessibilitySystemDialogSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySystemDialogSubrole, "NSAccessibilitySystemDialogSubrole", nil);
}

// NSString * const NSAccessibilityFloatingWindowSubrole;
static VALUE
osx_NSAccessibilityFloatingWindowSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityFloatingWindowSubrole, "NSAccessibilityFloatingWindowSubrole", nil);
}

// NSString * const NSAccessibilitySystemFloatingWindowSubrole;
static VALUE
osx_NSAccessibilitySystemFloatingWindowSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySystemFloatingWindowSubrole, "NSAccessibilitySystemFloatingWindowSubrole", nil);
}

// NSString * const NSAccessibilityIncrementArrowSubrole;
static VALUE
osx_NSAccessibilityIncrementArrowSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityIncrementArrowSubrole, "NSAccessibilityIncrementArrowSubrole", nil);
}

// NSString * const NSAccessibilityDecrementArrowSubrole;
static VALUE
osx_NSAccessibilityDecrementArrowSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDecrementArrowSubrole, "NSAccessibilityDecrementArrowSubrole", nil);
}

// NSString * const NSAccessibilityIncrementPageSubrole;
static VALUE
osx_NSAccessibilityIncrementPageSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityIncrementPageSubrole, "NSAccessibilityIncrementPageSubrole", nil);
}

// NSString * const NSAccessibilityDecrementPageSubrole;
static VALUE
osx_NSAccessibilityDecrementPageSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityDecrementPageSubrole, "NSAccessibilityDecrementPageSubrole", nil);
}

// NSString * const NSAccessibilitySearchFieldSubrole;
static VALUE
osx_NSAccessibilitySearchFieldSubrole(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilitySearchFieldSubrole, "NSAccessibilitySearchFieldSubrole", nil);
}

  /**** functions ****/
// void NSAccessibilityRaiseBadArgumentException ( id element , NSString * attribute , id value );
static VALUE
osx_NSAccessibilityRaiseBadArgumentException(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  id ns_a0;
  NSString * ns_a1;
  id ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSAccessibilityRaiseBadArgumentException", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, "NSAccessibilityRaiseBadArgumentException", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_ID, &ns_a2, "NSAccessibilityRaiseBadArgumentException", pool, 2);

NS_DURING
  NSAccessibilityRaiseBadArgumentException(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSAccessibilityRaiseBadArgumentException", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// id NSAccessibilityUnignoredAncestor ( id element );
static VALUE
osx_NSAccessibilityUnignoredAncestor(VALUE mdl, VALUE a0)
{
  id ns_result;

  id ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSAccessibilityUnignoredAncestor", pool, 0);

NS_DURING
  ns_result = NSAccessibilityUnignoredAncestor(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSAccessibilityUnignoredAncestor", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSAccessibilityUnignoredAncestor", pool);
  [pool release];
  return rb_result;
}

// id NSAccessibilityUnignoredDescendant ( id element );
static VALUE
osx_NSAccessibilityUnignoredDescendant(VALUE mdl, VALUE a0)
{
  id ns_result;

  id ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSAccessibilityUnignoredDescendant", pool, 0);

NS_DURING
  ns_result = NSAccessibilityUnignoredDescendant(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSAccessibilityUnignoredDescendant", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSAccessibilityUnignoredDescendant", pool);
  [pool release];
  return rb_result;
}

// NSArray * NSAccessibilityUnignoredChildren ( NSArray * originalChildren );
static VALUE
osx_NSAccessibilityUnignoredChildren(VALUE mdl, VALUE a0)
{
  NSArray * ns_result;

  NSArray * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSAccessibilityUnignoredChildren", pool, 0);

NS_DURING
  ns_result = NSAccessibilityUnignoredChildren(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSAccessibilityUnignoredChildren", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSAccessibilityUnignoredChildren", pool);
  [pool release];
  return rb_result;
}

// NSArray * NSAccessibilityUnignoredChildrenForOnlyChild ( id originalChild );
static VALUE
osx_NSAccessibilityUnignoredChildrenForOnlyChild(VALUE mdl, VALUE a0)
{
  NSArray * ns_result;

  id ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSAccessibilityUnignoredChildrenForOnlyChild", pool, 0);

NS_DURING
  ns_result = NSAccessibilityUnignoredChildrenForOnlyChild(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSAccessibilityUnignoredChildrenForOnlyChild", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSAccessibilityUnignoredChildrenForOnlyChild", pool);
  [pool release];
  return rb_result;
}

// void NSAccessibilityPostNotification ( id element , NSString * notification );
static VALUE
osx_NSAccessibilityPostNotification(VALUE mdl, VALUE a0, VALUE a1)
{

  id ns_a0;
  NSString * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSAccessibilityPostNotification", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, "NSAccessibilityPostNotification", pool, 1);

NS_DURING
  NSAccessibilityPostNotification(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSAccessibilityPostNotification", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

void init_NSAccessibility(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSAccessibilityErrorCodeExceptionInfo", osx_NSAccessibilityErrorCodeExceptionInfo, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRoleAttribute", osx_NSAccessibilityRoleAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRoleDescriptionAttribute", osx_NSAccessibilityRoleDescriptionAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySubroleAttribute", osx_NSAccessibilitySubroleAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityHelpAttribute", osx_NSAccessibilityHelpAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityTitleAttribute", osx_NSAccessibilityTitleAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityValueAttribute", osx_NSAccessibilityValueAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMinValueAttribute", osx_NSAccessibilityMinValueAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMaxValueAttribute", osx_NSAccessibilityMaxValueAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityEnabledAttribute", osx_NSAccessibilityEnabledAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityFocusedAttribute", osx_NSAccessibilityFocusedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityParentAttribute", osx_NSAccessibilityParentAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityChildrenAttribute", osx_NSAccessibilityChildrenAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityWindowAttribute", osx_NSAccessibilityWindowAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySelectedChildrenAttribute", osx_NSAccessibilitySelectedChildrenAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityVisibleChildrenAttribute", osx_NSAccessibilityVisibleChildrenAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityPositionAttribute", osx_NSAccessibilityPositionAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySizeAttribute", osx_NSAccessibilitySizeAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityContentsAttribute", osx_NSAccessibilityContentsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityPreviousContentsAttribute", osx_NSAccessibilityPreviousContentsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityNextContentsAttribute", osx_NSAccessibilityNextContentsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySelectedTextAttribute", osx_NSAccessibilitySelectedTextAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySelectedTextRangeAttribute", osx_NSAccessibilitySelectedTextRangeAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityNumberOfCharactersAttribute", osx_NSAccessibilityNumberOfCharactersAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityVisibleCharacterRangeAttribute", osx_NSAccessibilityVisibleCharacterRangeAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityLineForIndexParameterizedAttribute", osx_NSAccessibilityLineForIndexParameterizedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRangeForLineParameterizedAttribute", osx_NSAccessibilityRangeForLineParameterizedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityStringForRangeParameterizedAttribute", osx_NSAccessibilityStringForRangeParameterizedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRangeForPositionParameterizedAttribute", osx_NSAccessibilityRangeForPositionParameterizedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRangeForIndexParameterizedAttribute", osx_NSAccessibilityRangeForIndexParameterizedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityBoundsForRangeParameterizedAttribute", osx_NSAccessibilityBoundsForRangeParameterizedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRTFForRangeParameterizedAttribute", osx_NSAccessibilityRTFForRangeParameterizedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityStyleRangeForIndexParameterizedAttribute", osx_NSAccessibilityStyleRangeForIndexParameterizedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMainAttribute", osx_NSAccessibilityMainAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMinimizedAttribute", osx_NSAccessibilityMinimizedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityCloseButtonAttribute", osx_NSAccessibilityCloseButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityZoomButtonAttribute", osx_NSAccessibilityZoomButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMinimizeButtonAttribute", osx_NSAccessibilityMinimizeButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityToolbarButtonAttribute", osx_NSAccessibilityToolbarButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityProxyAttribute", osx_NSAccessibilityProxyAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityGrowAreaAttribute", osx_NSAccessibilityGrowAreaAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityModalAttribute", osx_NSAccessibilityModalAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDefaultButtonAttribute", osx_NSAccessibilityDefaultButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityCancelButtonAttribute", osx_NSAccessibilityCancelButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMenuBarAttribute", osx_NSAccessibilityMenuBarAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityWindowsAttribute", osx_NSAccessibilityWindowsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityFrontmostAttribute", osx_NSAccessibilityFrontmostAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityHiddenAttribute", osx_NSAccessibilityHiddenAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMainWindowAttribute", osx_NSAccessibilityMainWindowAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityFocusedWindowAttribute", osx_NSAccessibilityFocusedWindowAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityFocusedUIElementAttribute", osx_NSAccessibilityFocusedUIElementAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityHeaderAttribute", osx_NSAccessibilityHeaderAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityEditedAttribute", osx_NSAccessibilityEditedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityTabsAttribute", osx_NSAccessibilityTabsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityTitleUIElementAttribute", osx_NSAccessibilityTitleUIElementAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityHorizontalScrollBarAttribute", osx_NSAccessibilityHorizontalScrollBarAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityVerticalScrollBarAttribute", osx_NSAccessibilityVerticalScrollBarAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityOverflowButtonAttribute", osx_NSAccessibilityOverflowButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityIncrementButtonAttribute", osx_NSAccessibilityIncrementButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDecrementButtonAttribute", osx_NSAccessibilityDecrementButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityFilenameAttribute", osx_NSAccessibilityFilenameAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityExpandedAttribute", osx_NSAccessibilityExpandedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySelectedAttribute", osx_NSAccessibilitySelectedAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySplittersAttribute", osx_NSAccessibilitySplittersAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDocumentAttribute", osx_NSAccessibilityDocumentAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityOrientationAttribute", osx_NSAccessibilityOrientationAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityVerticalOrientationValue", osx_NSAccessibilityVerticalOrientationValue, 0);
  rb_define_module_function(mOSX, "NSAccessibilityHorizontalOrientationValue", osx_NSAccessibilityHorizontalOrientationValue, 0);
  rb_define_module_function(mOSX, "NSAccessibilityColumnTitlesAttribute", osx_NSAccessibilityColumnTitlesAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySearchButtonAttribute", osx_NSAccessibilitySearchButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySearchMenuAttribute", osx_NSAccessibilitySearchMenuAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityClearButtonAttribute", osx_NSAccessibilityClearButtonAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRowsAttribute", osx_NSAccessibilityRowsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityVisibleRowsAttribute", osx_NSAccessibilityVisibleRowsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySelectedRowsAttribute", osx_NSAccessibilitySelectedRowsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityColumnsAttribute", osx_NSAccessibilityColumnsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityVisibleColumnsAttribute", osx_NSAccessibilityVisibleColumnsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySelectedColumnsAttribute", osx_NSAccessibilitySelectedColumnsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySortDirectionAttribute", osx_NSAccessibilitySortDirectionAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDisclosingAttribute", osx_NSAccessibilityDisclosingAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDisclosedRowsAttribute", osx_NSAccessibilityDisclosedRowsAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDisclosedByRowAttribute", osx_NSAccessibilityDisclosedByRowAttribute, 0);
  rb_define_module_function(mOSX, "NSAccessibilityPressAction", osx_NSAccessibilityPressAction, 0);
  rb_define_module_function(mOSX, "NSAccessibilityIncrementAction", osx_NSAccessibilityIncrementAction, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDecrementAction", osx_NSAccessibilityDecrementAction, 0);
  rb_define_module_function(mOSX, "NSAccessibilityConfirmAction", osx_NSAccessibilityConfirmAction, 0);
  rb_define_module_function(mOSX, "NSAccessibilityPickAction", osx_NSAccessibilityPickAction, 0);
  rb_define_module_function(mOSX, "NSAccessibilityCancelAction", osx_NSAccessibilityCancelAction, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRaiseAction", osx_NSAccessibilityRaiseAction, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMainWindowChangedNotification", osx_NSAccessibilityMainWindowChangedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityFocusedWindowChangedNotification", osx_NSAccessibilityFocusedWindowChangedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityFocusedUIElementChangedNotification", osx_NSAccessibilityFocusedUIElementChangedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityApplicationActivatedNotification", osx_NSAccessibilityApplicationActivatedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityApplicationDeactivatedNotification", osx_NSAccessibilityApplicationDeactivatedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityApplicationHiddenNotification", osx_NSAccessibilityApplicationHiddenNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityApplicationShownNotification", osx_NSAccessibilityApplicationShownNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityWindowCreatedNotification", osx_NSAccessibilityWindowCreatedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityWindowMovedNotification", osx_NSAccessibilityWindowMovedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityWindowResizedNotification", osx_NSAccessibilityWindowResizedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityWindowMiniaturizedNotification", osx_NSAccessibilityWindowMiniaturizedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityWindowDeminiaturizedNotification", osx_NSAccessibilityWindowDeminiaturizedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDrawerCreatedNotification", osx_NSAccessibilityDrawerCreatedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySheetCreatedNotification", osx_NSAccessibilitySheetCreatedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityValueChangedNotification", osx_NSAccessibilityValueChangedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityUIElementDestroyedNotification", osx_NSAccessibilityUIElementDestroyedNotification, 0);
  rb_define_module_function(mOSX, "NSAccessibilityUnknownRole", osx_NSAccessibilityUnknownRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityButtonRole", osx_NSAccessibilityButtonRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRadioButtonRole", osx_NSAccessibilityRadioButtonRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityCheckBoxRole", osx_NSAccessibilityCheckBoxRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySliderRole", osx_NSAccessibilitySliderRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityTabGroupRole", osx_NSAccessibilityTabGroupRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityTextFieldRole", osx_NSAccessibilityTextFieldRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityStaticTextRole", osx_NSAccessibilityStaticTextRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityTextAreaRole", osx_NSAccessibilityTextAreaRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityScrollAreaRole", osx_NSAccessibilityScrollAreaRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityPopUpButtonRole", osx_NSAccessibilityPopUpButtonRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMenuButtonRole", osx_NSAccessibilityMenuButtonRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityTableRole", osx_NSAccessibilityTableRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityApplicationRole", osx_NSAccessibilityApplicationRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityGroupRole", osx_NSAccessibilityGroupRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRadioGroupRole", osx_NSAccessibilityRadioGroupRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityListRole", osx_NSAccessibilityListRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityScrollBarRole", osx_NSAccessibilityScrollBarRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityValueIndicatorRole", osx_NSAccessibilityValueIndicatorRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityImageRole", osx_NSAccessibilityImageRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMenuBarRole", osx_NSAccessibilityMenuBarRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMenuRole", osx_NSAccessibilityMenuRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMenuItemRole", osx_NSAccessibilityMenuItemRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityColumnRole", osx_NSAccessibilityColumnRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityRowRole", osx_NSAccessibilityRowRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityToolbarRole", osx_NSAccessibilityToolbarRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityBusyIndicatorRole", osx_NSAccessibilityBusyIndicatorRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityProgressIndicatorRole", osx_NSAccessibilityProgressIndicatorRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityWindowRole", osx_NSAccessibilityWindowRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDrawerRole", osx_NSAccessibilityDrawerRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySystemWideRole", osx_NSAccessibilitySystemWideRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityOutlineRole", osx_NSAccessibilityOutlineRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityIncrementorRole", osx_NSAccessibilityIncrementorRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityBrowserRole", osx_NSAccessibilityBrowserRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityComboBoxRole", osx_NSAccessibilityComboBoxRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySplitGroupRole", osx_NSAccessibilitySplitGroupRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySplitterRole", osx_NSAccessibilitySplitterRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityColorWellRole", osx_NSAccessibilityColorWellRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityGrowAreaRole", osx_NSAccessibilityGrowAreaRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySheetRole", osx_NSAccessibilitySheetRole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityUnknownSubrole", osx_NSAccessibilityUnknownSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityCloseButtonSubrole", osx_NSAccessibilityCloseButtonSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityZoomButtonSubrole", osx_NSAccessibilityZoomButtonSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityMinimizeButtonSubrole", osx_NSAccessibilityMinimizeButtonSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityToolbarButtonSubrole", osx_NSAccessibilityToolbarButtonSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityTableRowSubrole", osx_NSAccessibilityTableRowSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityOutlineRowSubrole", osx_NSAccessibilityOutlineRowSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySecureTextFieldSubrole", osx_NSAccessibilitySecureTextFieldSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityStandardWindowSubrole", osx_NSAccessibilityStandardWindowSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDialogSubrole", osx_NSAccessibilityDialogSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySystemDialogSubrole", osx_NSAccessibilitySystemDialogSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityFloatingWindowSubrole", osx_NSAccessibilityFloatingWindowSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySystemFloatingWindowSubrole", osx_NSAccessibilitySystemFloatingWindowSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityIncrementArrowSubrole", osx_NSAccessibilityIncrementArrowSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDecrementArrowSubrole", osx_NSAccessibilityDecrementArrowSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityIncrementPageSubrole", osx_NSAccessibilityIncrementPageSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilityDecrementPageSubrole", osx_NSAccessibilityDecrementPageSubrole, 0);
  rb_define_module_function(mOSX, "NSAccessibilitySearchFieldSubrole", osx_NSAccessibilitySearchFieldSubrole, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSAccessibilityRaiseBadArgumentException", osx_NSAccessibilityRaiseBadArgumentException, 3);
  rb_define_module_function(mOSX, "NSAccessibilityUnignoredAncestor", osx_NSAccessibilityUnignoredAncestor, 1);
  rb_define_module_function(mOSX, "NSAccessibilityUnignoredDescendant", osx_NSAccessibilityUnignoredDescendant, 1);
  rb_define_module_function(mOSX, "NSAccessibilityUnignoredChildren", osx_NSAccessibilityUnignoredChildren, 1);
  rb_define_module_function(mOSX, "NSAccessibilityUnignoredChildrenForOnlyChild", osx_NSAccessibilityUnignoredChildrenForOnlyChild, 1);
  rb_define_module_function(mOSX, "NSAccessibilityPostNotification", osx_NSAccessibilityPostNotification, 2);
}
