#
#  ___FILENAME___
#  ___PROJECTNAME___
#
#  Created by ___FULLUSERNAME___ on ___DATE___.
#___COPYRIGHT___
#

require 'osx/cocoa'
OSX.require_framework 'CoreData'

class ___VARIABLE_classPrefix___Document < OSX::NSPersistentDocument

	def init
		super_init
		if self
			# Add your subclass-specific initialization here.
			# If an error occurs here, send a [self release] message and return nil.
		end
		return self
	end

	def windowNibName
		# Override returning the nib file name of the document
		# If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
		return "___VARIABLE_classPrefix___Document"
	end

	def windowControllerDidLoadNib_(controller)
		super_windowControllerDidLoadNib(controller)
		# Add any code here that needs to be executed once the windowController has loaded the document's window.
	end

	def self.autosavesInPlace
		return true
	end

end

