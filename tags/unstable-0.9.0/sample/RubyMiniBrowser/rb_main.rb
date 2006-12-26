require 'osx/cocoa'

module OSX
  module OCObjWrapper
    def objc_send(*args)
      mname = ""
      margs = []
      args.each_with_index do |val, index|
        if index % 2 == 0 then
          mname << val.to_s << ':'
        else
          margs << val
        end
      end
      return self.ocm_send(mname, *margs)
    end
    alias _  objc_send
  end
end

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end

if $0 == __FILE__ then
  rb_main_init
  OSX.NSApplicationMain(0, nil)
end
