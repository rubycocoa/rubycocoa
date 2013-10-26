#
#  ___FILENAME___
#  ___PROJECTNAME___
#
#  Created by ___FULLUSERNAME___ on ___DATE___.
#___COPYRIGHT___
#

require 'osx/cocoa'

class ___VARIABLE_classPrefix:identifier___Document < OSX::NSDocument

	def init
		super_init
		if self
			# Add your subclass-specific initialization here.
		end
		return self
	end

	def windowNibName
		# Override returning the nib file name of the document
		# If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
		return "___VARIABLE_classPrefix:identifier___Document"
	end

	def windowControllerDidLoadNib_(controller)
		super_windowControllerDidLoadNib(controller)
		# Add any code here that needs to be executed once the windowController has loaded the document's window.
	end

	def dataOfType_error_(typename, outError)
		# Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
		# You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    	exception = OSX::NSException.exceptionWithName_reason_userInfo_("UnimplementedMethod", "#{__method__} is unimplemented", nil)
    	exception.raise
		return nil
	end

	def readFromData_ofType_error_(data, typeName, outError)
		# Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
		# You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
		# If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    	exception = OSX::NSException.exceptionWithName_reason_userInfo_("UnimplementedMethod", "#{__method__} is unimplemented", nil)
    	exception.raise
		return nil
	end

	def self.autosavesInPlace
		return true
	end

end
