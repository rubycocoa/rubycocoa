#
#  MyDocument.rb
#  ÇPROJECTNAMEÈ
#
#  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
#  Copyright (c) ÇYEARÈ ÇORGANIZATIONNAMEÈ. All rights reserved.
#


require 'osx/cocoa'

class MyDocument < OSX:: NSPersistentDocument

  ns_overrides 'windowNibName', 'windowControllerDidLoadNib:'

  def windowNibName
    return "MyDocument"
  end

  def windowControllerDidLoadNib (aController)
    super_windowControllerDidLoadNib(aController)
    # user interface preparation code
  end

end
