# $Id$
require 'osx/cocoa'

class Converter < OSX::NSObject
  kvc_accessor :dollarsToConvert, :exchangeRate
  
  def amountInOtherCurrency
    return @dollarsToConvert.to_f * @exchangeRate.to_f
  end
  
  Converter.setKeys([:dollarsToConvert, :exchangeRate],
    :triggerChangeNotificationsForDependentKey, :amountInOtherCurrency)

end
