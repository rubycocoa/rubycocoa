#
# $Id$
#

require 'osx/cocoa'

class CalcController < OSX::NSObject

  ib_outlets :fieldA, :fieldB, :fieldResult
  ib_outlets :menuOp, :rbtnsOp, :textOp

  def awakeFromNib
    @op_syms = [ :plus, :minus, :mul, :div ].freeze
    @op_dic = { :plus => '+', :minus => '-', :mul => '*', :div => '/' }.freeze
    update_op (op_value_rbtn)
    @fieldA.setFloatValue (rand(100).to_f)
    @fieldB.setFloatValue (rand(100).to_f)
    calc
  end

  def calc (sender = nil)
    a = @fieldA.floatValue
    b = @fieldB.floatValue
    r = a.send (@op_dic[op_value_rbtn], b)
    @fieldResult.setFloatValue (r)
    @fieldA.selectText (self)
  end

  def changeOperator (sender = nil)
    if sender.isEqual?(@rbtnsOp) then
      update_op (op_value_rbtn)
    elsif sender.isKindOfClass?(OSX::NSMenuItem) then
      update_op (sender.title.to_s.intern)
    end
  end

  def shuffle (sender = nil)
    fields = [ @fieldA, @fieldB, @fieldResult ]
    vals = fields.map {|f| f.floatValue }
    3.times do |i|
      ii = rand (3-i)
      fields[i].setFloatValue(vals[ii])
      vals.delete_at(ii)
    end
    @fieldA.selectText (self)
  end

  def windowShouldClose (sender = nil)
    OSX.NSApp.stop (self)
    true
  end

  private

  def update_op(opval)
    set_op_value_text (opval)
    set_op_value_rbtn (opval)
    set_op_value_menu (opval)
  end

  def set_op_value_text(sym)
    @textOp.setStringValue (@op_dic[sym])
  end

  def op_value_rbtn
    @rbtnsOp.selectedCell.title.to_s.intern
  end

  def set_op_value_rbtn(sym)
    @op_syms.each_with_index do |s,i|
      if sym == s then
	@rbtnsOp.selectCellAtRow (0, :column, i)
	break
      end
    end
  end

  def op_value_menu
    result = nil
    @op_syms.each do |sym|
      state = @menuOp.submenu.itemWithTitle(sym.to_s).state
      if state == OSX::NSOnState then
	result = sym
	break
      end
    end
    result
  end

  def set_op_value_menu(sym)
    @op_syms.each do |s|
      val = (sym == s) ? OSX::NSOnState : OSX::NSOffState
      mi = @menuOp.submenu.itemWithTitle(s.to_s)
      mi.setState(val)
    end
  end

end
