require 'osx/cocoa'

class Expense

  attr_accessor :date, :category, :amount

  DEFAULT_CATEGORY = 'Food'
  CALFMT = OSX::NSDateFormatter.alloc.init.dateFormat

  def _dump(depth)
    Marshal.dump([date_to_str, @category.to_s, @amount.to_i])
  end

  def Expense._load(str)
    datestr, category, amount = Marshal.load(str)
    obj = Expense.new
    obj.category = category
    obj.amount = amount
    obj.date = str_to_date (datestr)
    obj
  end

  def initialize
    @date = OSX::NSCalendarDate.date
    @category = DEFAULT_CATEGORY
    @amount = 0			# OSX::NSDecimalNumber.zero
  end

  def date_to_str
    @date.descriptionWithCalendarFormat(CALFMT).to_s
  end

  def Expense.str_to_date(str)
    OSX::NSCalendarDate.dateWithString (str, :calendarFormat, CALFMT)
  end

end
