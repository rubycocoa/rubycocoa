require 'osx/cocoa'
require 'Expense'

class MyDataSource < OSX::OCObject

  ib_loadable :NSObject

  def initialize
    @expenses = Array.new
  end

  def awakeFromNib
    op = OSX::NSOpenPanel.openPanel
    answer = op.runModalForTypes [ "expenses" ]
    if answer == OSX::NSOKButton then
      File.open(op.filename.to_s) do |io|
	@expenses = Marshal.load(io)
      end
    else
      @expenses = generateTestData
    end
  end

  def windowShouldClose(win)
    answer = OSX::NSRunAlertPanel("Save Expenses", "Do you want to save?", 
			 "Save", "Don't Save", nil)
    if answer == OSX::NSAlertDefaultReturn then
      sp = OSX::NSSavePanel.savePanel
      sp.setRequiredFileType "expenses"
      answer = sp.runModal
      if answer == OSX::NSOKButton then
	File.open(sp.filename.to_s, "w") do |io|
	  Marshal.dump(@expenses, io)
	end
      end
    end
    true
  end

  def numberOfRowsInTableView (view)
    @expenses.size
  end

  def tableView_objectValueForTableColumn_row (view, column, row)
    expense = @expenses[row]
    attr = column.identifier.to_s
    expense.send (attr)
  end

  def tableView_setObjectValue_forTableColumn_row (view, val, column, row)
    attr = column.identifier.to_s
    @expenses[row].send ("#{attr}=", val)
  end

  def generateTestData
    ary = Array.new
    15.times do |i|
      exp = Expense.new
      exp.amount = i	       # OSX::NSDecimalNumber.numberWithInt(i)
      ary.push (exp)
    end
    ary
  end

end
