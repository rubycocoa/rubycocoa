#
#  KeyValueCoding.rb
#  Spotlight
#
#  Created by Norberto Ortigoza on 9/11/05.
#  Copyright (c) 2005 CrossHorizons. All rights reserved.
#

# Objective-C's reflection can not find properties defined in the Ruby World.
# KeyValueCoding adds method implementations of KVC to NSObject class and includes enable_KeyValueCoding to NSBehaviorAttachment.
# Indeed any class can use this support without inheriting from another class or including a module.
# This implementation always try to resolve first the methods from Ruby. If we can not resolve these we give a chance to Objective-C 
module OSX
	
	module NSBehaviorAttachment
		# Invoke it from your class definition
		# If you need to include other methods belonged to KVC include their override in this method 
		def enable_kvc
			ns_overrides 'valueForKey:'
			ns_overrides 'setValue:forKey:'
		end
	end
	
	class NSObject
		# Ruby uses diferent conventions than Objective-C for naming accesors and variables, so we will use them
		# The algorithm does the following:
		# 1. Searchs for a method "aKey". If such a method is found the algorithm use it
		# 2. Otherwise it looks for a method "aKey?". If such a method is found the algorithm use it
		# 3. Otherwise it looks for an instance variable named "@<aKey>".
		# 4. As last resort we invoke the Objective-C's mechanism   
		def valueForKey(aKey)
			if method = kvc_accessor(aKey.to_s) #We need a Ruby String not a NSString					
				return self.send(method) 
			elsif self.instance_variables.include?("@" + aKey.to_s)
				return self.instance_variable_get("@" + aKey.to_s)
			else
				super_valueForKey(aKey)
			end
		end
	
		# The algorithm does the following:
		# 1. Searchs for a property "aKey=". If such a property is found sets the aValue using it
		# 2. Otherwise it looks for an instance variable named "@<aKey>".
		# 3. As last resort we invoke the Objective-C's mechanism   
		def setValue_forKey(aValue, aKey)		
			if self.respond_to?(aKey.to_s + "=", true) then
				willChangeValueForKey(aKey)
				self.send(aKey.to_s + "=", aValue)
				didChangeValueForKey(aKey)
			elsif self.instance_variables.include?("@" + aKey.to_s)
				willChangeValueForKey(aKey)
				self.instance_variable_set("@" + aKey.to_s, aValue)
				didChangeValueForKey(aKey)
			else
				super_setValue_forKey(aValue, aKey)
			end
		end
		
		# Method taken from RubyCocoa FAQ
		# Provided for Kimura Wataru (http://homepage3.nifty.com/kimuraw/d/2004/06.html#12)
		def kvc_accessor(key)
			[key, key + '?'].each do |m|
				return m if respond_to?(m, true)  #We look for public, private and protected methods
			end
			return nil # accessor not found
		end		
	end
end

