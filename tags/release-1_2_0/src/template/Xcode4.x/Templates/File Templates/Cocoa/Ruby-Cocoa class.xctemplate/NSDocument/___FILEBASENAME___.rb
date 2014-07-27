#
#  ___FILENAME___
#  ___PROJECTNAME___
#
#  Created by ___FULLUSERNAME___ on ___DATE___.
#___COPYRIGHT___
#

require 'osx/cocoa'

class ___FILEBASENAMEASIDENTIFIER___ < OSX::NSDocument

  def init
    self = super_init
    if self
      # Add your subclass-specific initialization here.
    end
    return self
  end

  def windowNibName
      # Override returning the nib file name of the document
      # If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
      return "___FILEBASENAMEASIDENTIFIER___"
  end

  def windowControllerDidLoadNib_(controller)
    super_windowControllerDidLoadNib_(controller)
    # Add any code here that needs to be executed once the windowController has loaded the document's window.
  end

  def dataOfType_error_(typeName, outError)
    # Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    # You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    if outError
      outError.assign(OSX::NSError.errorWithDomain_code_userInfo(OSX::NSOSStatusErrorDomain, unimpErr, nil))
    end
    return nil
  end

  def readFromData_ofType_error_(data, typeName, outError)
    # Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    # You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    # If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    if outError
      outError.assign(OSX::NSError.errorWithDomain_code_userInfo_(OSX::NSOSStatusErrorDomain, unimpErr, nil))
    end
    return true
  end

  def self.autosavesInPlace
    return true
  end

end
