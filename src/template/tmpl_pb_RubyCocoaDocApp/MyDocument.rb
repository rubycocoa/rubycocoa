#
#  MyDocument.h
#  ÇPROJECTNAMEÈ
#
#  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
#  Copyright (c) 2001 ÇORGANIZATIONNAMEÈ. All rights reserved.
#

require 'osx/cocoa'

class MyDocument < OSX::NSDocument

  ns_overrides 'windowNibName', 'windowControllerDidLoadNib:',
    'dataRepresentationOfType:', 'loadDataRepresentation:ofType:'

  def windowNibName
    # Implement this to return a nib to load OR implement
    # -makeWindowControllers to manually create your controllers.
    return "MyDocument"
  end
    
  def windowControllerDidLoadNib (aController)
    super_windowControllerDidLoadNib (aController)
    # Add any code here that need to be executed once the
    # windowController has loaded the document's window.
  end

  def dataRepresentationOfType (type)
    # Implement to provide a persistent data representation of your
    # document OR remove this and implement the file-wrapper or file
    # path based save methods.
    return nil
  end
    
  def loadDataRepresentation_ofType (data, type)
    # Implement to load a persistent data representation of your
    # document OR remove this and implement the file-wrapper or file
    # path based load methods.
    return true
  end

end
