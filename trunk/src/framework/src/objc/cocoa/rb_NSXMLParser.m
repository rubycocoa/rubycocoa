#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSXMLParserErrorDomain;
static VALUE
osx_NSXMLParserErrorDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSXMLParserErrorDomain, "NSXMLParserErrorDomain", nil);
}

void init_NSXMLParser(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSXMLParserInternalError", INT2NUM(NSXMLParserInternalError));
  rb_define_const(mOSX, "NSXMLParserOutOfMemoryError", INT2NUM(NSXMLParserOutOfMemoryError));
  rb_define_const(mOSX, "NSXMLParserDocumentStartError", INT2NUM(NSXMLParserDocumentStartError));
  rb_define_const(mOSX, "NSXMLParserEmptyDocumentError", INT2NUM(NSXMLParserEmptyDocumentError));
  rb_define_const(mOSX, "NSXMLParserPrematureDocumentEndError", INT2NUM(NSXMLParserPrematureDocumentEndError));
  rb_define_const(mOSX, "NSXMLParserInvalidHexCharacterRefError", INT2NUM(NSXMLParserInvalidHexCharacterRefError));
  rb_define_const(mOSX, "NSXMLParserInvalidDecimalCharacterRefError", INT2NUM(NSXMLParserInvalidDecimalCharacterRefError));
  rb_define_const(mOSX, "NSXMLParserInvalidCharacterRefError", INT2NUM(NSXMLParserInvalidCharacterRefError));
  rb_define_const(mOSX, "NSXMLParserInvalidCharacterError", INT2NUM(NSXMLParserInvalidCharacterError));
  rb_define_const(mOSX, "NSXMLParserCharacterRefAtEOFError", INT2NUM(NSXMLParserCharacterRefAtEOFError));
  rb_define_const(mOSX, "NSXMLParserCharacterRefInPrologError", INT2NUM(NSXMLParserCharacterRefInPrologError));
  rb_define_const(mOSX, "NSXMLParserCharacterRefInEpilogError", INT2NUM(NSXMLParserCharacterRefInEpilogError));
  rb_define_const(mOSX, "NSXMLParserCharacterRefInDTDError", INT2NUM(NSXMLParserCharacterRefInDTDError));
  rb_define_const(mOSX, "NSXMLParserEntityRefAtEOFError", INT2NUM(NSXMLParserEntityRefAtEOFError));
  rb_define_const(mOSX, "NSXMLParserEntityRefInPrologError", INT2NUM(NSXMLParserEntityRefInPrologError));
  rb_define_const(mOSX, "NSXMLParserEntityRefInEpilogError", INT2NUM(NSXMLParserEntityRefInEpilogError));
  rb_define_const(mOSX, "NSXMLParserEntityRefInDTDError", INT2NUM(NSXMLParserEntityRefInDTDError));
  rb_define_const(mOSX, "NSXMLParserParsedEntityRefAtEOFError", INT2NUM(NSXMLParserParsedEntityRefAtEOFError));
  rb_define_const(mOSX, "NSXMLParserParsedEntityRefInPrologError", INT2NUM(NSXMLParserParsedEntityRefInPrologError));
  rb_define_const(mOSX, "NSXMLParserParsedEntityRefInEpilogError", INT2NUM(NSXMLParserParsedEntityRefInEpilogError));
  rb_define_const(mOSX, "NSXMLParserParsedEntityRefInInternalSubsetError", INT2NUM(NSXMLParserParsedEntityRefInInternalSubsetError));
  rb_define_const(mOSX, "NSXMLParserEntityReferenceWithoutNameError", INT2NUM(NSXMLParserEntityReferenceWithoutNameError));
  rb_define_const(mOSX, "NSXMLParserEntityReferenceMissingSemiError", INT2NUM(NSXMLParserEntityReferenceMissingSemiError));
  rb_define_const(mOSX, "NSXMLParserParsedEntityRefNoNameError", INT2NUM(NSXMLParserParsedEntityRefNoNameError));
  rb_define_const(mOSX, "NSXMLParserParsedEntityRefMissingSemiError", INT2NUM(NSXMLParserParsedEntityRefMissingSemiError));
  rb_define_const(mOSX, "NSXMLParserUndeclaredEntityError", INT2NUM(NSXMLParserUndeclaredEntityError));
  rb_define_const(mOSX, "NSXMLParserUnparsedEntityError", INT2NUM(NSXMLParserUnparsedEntityError));
  rb_define_const(mOSX, "NSXMLParserEntityIsExternalError", INT2NUM(NSXMLParserEntityIsExternalError));
  rb_define_const(mOSX, "NSXMLParserEntityIsParameterError", INT2NUM(NSXMLParserEntityIsParameterError));
  rb_define_const(mOSX, "NSXMLParserUnknownEncodingError", INT2NUM(NSXMLParserUnknownEncodingError));
  rb_define_const(mOSX, "NSXMLParserEncodingNotSupportedError", INT2NUM(NSXMLParserEncodingNotSupportedError));
  rb_define_const(mOSX, "NSXMLParserStringNotStartedError", INT2NUM(NSXMLParserStringNotStartedError));
  rb_define_const(mOSX, "NSXMLParserStringNotClosedError", INT2NUM(NSXMLParserStringNotClosedError));
  rb_define_const(mOSX, "NSXMLParserNamespaceDeclarationError", INT2NUM(NSXMLParserNamespaceDeclarationError));
  rb_define_const(mOSX, "NSXMLParserEntityNotStartedError", INT2NUM(NSXMLParserEntityNotStartedError));
  rb_define_const(mOSX, "NSXMLParserEntityNotFinishedError", INT2NUM(NSXMLParserEntityNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserLessThanSymbolInAttributeError", INT2NUM(NSXMLParserLessThanSymbolInAttributeError));
  rb_define_const(mOSX, "NSXMLParserAttributeNotStartedError", INT2NUM(NSXMLParserAttributeNotStartedError));
  rb_define_const(mOSX, "NSXMLParserAttributeNotFinishedError", INT2NUM(NSXMLParserAttributeNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserAttributeHasNoValueError", INT2NUM(NSXMLParserAttributeHasNoValueError));
  rb_define_const(mOSX, "NSXMLParserAttributeRedefinedError", INT2NUM(NSXMLParserAttributeRedefinedError));
  rb_define_const(mOSX, "NSXMLParserLiteralNotStartedError", INT2NUM(NSXMLParserLiteralNotStartedError));
  rb_define_const(mOSX, "NSXMLParserLiteralNotFinishedError", INT2NUM(NSXMLParserLiteralNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserCommentNotFinishedError", INT2NUM(NSXMLParserCommentNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserProcessingInstructionNotStartedError", INT2NUM(NSXMLParserProcessingInstructionNotStartedError));
  rb_define_const(mOSX, "NSXMLParserProcessingInstructionNotFinishedError", INT2NUM(NSXMLParserProcessingInstructionNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserNotationNotStartedError", INT2NUM(NSXMLParserNotationNotStartedError));
  rb_define_const(mOSX, "NSXMLParserNotationNotFinishedError", INT2NUM(NSXMLParserNotationNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserAttributeListNotStartedError", INT2NUM(NSXMLParserAttributeListNotStartedError));
  rb_define_const(mOSX, "NSXMLParserAttributeListNotFinishedError", INT2NUM(NSXMLParserAttributeListNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserMixedContentDeclNotStartedError", INT2NUM(NSXMLParserMixedContentDeclNotStartedError));
  rb_define_const(mOSX, "NSXMLParserMixedContentDeclNotFinishedError", INT2NUM(NSXMLParserMixedContentDeclNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserElementContentDeclNotStartedError", INT2NUM(NSXMLParserElementContentDeclNotStartedError));
  rb_define_const(mOSX, "NSXMLParserElementContentDeclNotFinishedError", INT2NUM(NSXMLParserElementContentDeclNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserXMLDeclNotStartedError", INT2NUM(NSXMLParserXMLDeclNotStartedError));
  rb_define_const(mOSX, "NSXMLParserXMLDeclNotFinishedError", INT2NUM(NSXMLParserXMLDeclNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserConditionalSectionNotStartedError", INT2NUM(NSXMLParserConditionalSectionNotStartedError));
  rb_define_const(mOSX, "NSXMLParserConditionalSectionNotFinishedError", INT2NUM(NSXMLParserConditionalSectionNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserExternalSubsetNotFinishedError", INT2NUM(NSXMLParserExternalSubsetNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserDOCTYPEDeclNotFinishedError", INT2NUM(NSXMLParserDOCTYPEDeclNotFinishedError));
  rb_define_const(mOSX, "NSXMLParserMisplacedCDATAEndStringError", INT2NUM(NSXMLParserMisplacedCDATAEndStringError));
  rb_define_const(mOSX, "NSXMLParserCDATANotFinishedError", INT2NUM(NSXMLParserCDATANotFinishedError));
  rb_define_const(mOSX, "NSXMLParserMisplacedXMLDeclarationError", INT2NUM(NSXMLParserMisplacedXMLDeclarationError));
  rb_define_const(mOSX, "NSXMLParserSpaceRequiredError", INT2NUM(NSXMLParserSpaceRequiredError));
  rb_define_const(mOSX, "NSXMLParserSeparatorRequiredError", INT2NUM(NSXMLParserSeparatorRequiredError));
  rb_define_const(mOSX, "NSXMLParserNMTOKENRequiredError", INT2NUM(NSXMLParserNMTOKENRequiredError));
  rb_define_const(mOSX, "NSXMLParserNAMERequiredError", INT2NUM(NSXMLParserNAMERequiredError));
  rb_define_const(mOSX, "NSXMLParserPCDATARequiredError", INT2NUM(NSXMLParserPCDATARequiredError));
  rb_define_const(mOSX, "NSXMLParserURIRequiredError", INT2NUM(NSXMLParserURIRequiredError));
  rb_define_const(mOSX, "NSXMLParserPublicIdentifierRequiredError", INT2NUM(NSXMLParserPublicIdentifierRequiredError));
  rb_define_const(mOSX, "NSXMLParserLTRequiredError", INT2NUM(NSXMLParserLTRequiredError));
  rb_define_const(mOSX, "NSXMLParserGTRequiredError", INT2NUM(NSXMLParserGTRequiredError));
  rb_define_const(mOSX, "NSXMLParserLTSlashRequiredError", INT2NUM(NSXMLParserLTSlashRequiredError));
  rb_define_const(mOSX, "NSXMLParserEqualExpectedError", INT2NUM(NSXMLParserEqualExpectedError));
  rb_define_const(mOSX, "NSXMLParserTagNameMismatchError", INT2NUM(NSXMLParserTagNameMismatchError));
  rb_define_const(mOSX, "NSXMLParserUnfinishedTagError", INT2NUM(NSXMLParserUnfinishedTagError));
  rb_define_const(mOSX, "NSXMLParserStandaloneValueError", INT2NUM(NSXMLParserStandaloneValueError));
  rb_define_const(mOSX, "NSXMLParserInvalidEncodingNameError", INT2NUM(NSXMLParserInvalidEncodingNameError));
  rb_define_const(mOSX, "NSXMLParserCommentContainsDoubleHyphenError", INT2NUM(NSXMLParserCommentContainsDoubleHyphenError));
  rb_define_const(mOSX, "NSXMLParserInvalidEncodingError", INT2NUM(NSXMLParserInvalidEncodingError));
  rb_define_const(mOSX, "NSXMLParserExternalStandaloneEntityError", INT2NUM(NSXMLParserExternalStandaloneEntityError));
  rb_define_const(mOSX, "NSXMLParserInvalidConditionalSectionError", INT2NUM(NSXMLParserInvalidConditionalSectionError));
  rb_define_const(mOSX, "NSXMLParserEntityValueRequiredError", INT2NUM(NSXMLParserEntityValueRequiredError));
  rb_define_const(mOSX, "NSXMLParserNotWellBalancedError", INT2NUM(NSXMLParserNotWellBalancedError));
  rb_define_const(mOSX, "NSXMLParserExtraContentError", INT2NUM(NSXMLParserExtraContentError));
  rb_define_const(mOSX, "NSXMLParserInvalidCharacterInEntityError", INT2NUM(NSXMLParserInvalidCharacterInEntityError));
  rb_define_const(mOSX, "NSXMLParserParsedEntityRefInInternalError", INT2NUM(NSXMLParserParsedEntityRefInInternalError));
  rb_define_const(mOSX, "NSXMLParserEntityRefLoopError", INT2NUM(NSXMLParserEntityRefLoopError));
  rb_define_const(mOSX, "NSXMLParserEntityBoundaryError", INT2NUM(NSXMLParserEntityBoundaryError));
  rb_define_const(mOSX, "NSXMLParserInvalidURIError", INT2NUM(NSXMLParserInvalidURIError));
  rb_define_const(mOSX, "NSXMLParserURIFragmentError", INT2NUM(NSXMLParserURIFragmentError));
  rb_define_const(mOSX, "NSXMLParserNoDTDError", INT2NUM(NSXMLParserNoDTDError));
  rb_define_const(mOSX, "NSXMLParserDelegateAbortedParseError", INT2NUM(NSXMLParserDelegateAbortedParseError));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSXMLParserErrorDomain", osx_NSXMLParserErrorDomain, 0);
}
