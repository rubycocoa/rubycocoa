#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'osx/objc/foundation'
require 'osx/objc/appkit'

module OSX

  # from NSBundle
  def NSLocalizedString (key, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table (key, "", nil)
  end
  def NSLocalizedStringFromTable (key, tbl, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table (key, "", tbl)
  end
  def NSLocalizedStringFromTableInBundle (key, tbl, bundle, comment = nil)
    bundle.localizedStringForKey_value_table (key, "", tbl)
  end
  module_function :NSLocalizedStringFromTableInBundle
  module_function :NSLocalizedStringFromTable
  module_function :NSLocalizedString

end
