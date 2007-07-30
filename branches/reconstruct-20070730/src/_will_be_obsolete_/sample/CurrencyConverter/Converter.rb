# $Id$
require 'osx/cocoa'

class Converter < OSX::NSObject
  kvc_accessor :dollarsToConvert, :exchangeRate
  kvc_depends_on([:dollarsToConvert, :exchangeRate], :amountInOtherCurrency)
  
  def amountInOtherCurrency
    return @dollarsToConvert.to_f * @exchangeRate.to_f
  end

end
