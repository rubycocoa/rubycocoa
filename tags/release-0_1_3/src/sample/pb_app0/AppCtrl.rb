#
# $Id$
#
require 'osx/ocobject'

class AppCtrl < OSX::OCObject

  ib_loadable
  ib_outlets :monthField, :dayField, :mulField

  def initialize
    super
    @close_cnt = 3
  end

  def awakeFromNib
    @monthField.setIntValue  Time.now.month
    @dayField.setIntValue Time.now.day
    convert
  end

  def convert (sender = nil)
    val = @monthField.intValue * @dayField.intValue
    @mulField.setIntValue (val)
    @monthField.selectText (self)
  end

  def windowShouldClose (sender = nil)
    @close_cnt -= 1
    @close_cnt == 0
  end    

end
