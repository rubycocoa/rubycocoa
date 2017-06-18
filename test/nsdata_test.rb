#
#  $Id$
#
#  Copyright (c) 2003-2005 FUJIMOTO Hisakuni
#

require 'test/unit'
require 'osx/cocoa'

class TC_NSData < Test::Unit::TestCase
  include OSX

  def test_s_data
    data = NSData.data
    assert( data.isKindOfClass(NSData) )
    assert_equal( 0, data.length )
    assert_nil( data.bytes )
  end

  def test_s_dataWithBytes_length
    src = "hello world"
    data = NSData.dataWithBytes_length( src )
    assert( data.isKindOfClass(NSData) )
    assert_equal( src.size, data.length )
    assert_kind_of( ObjcPtr, data.bytes )
  end

  def test_s_dataWithContentsOfFile
    src = File.open('/etc/passwd').read
    data = NSData.dataWithContentsOfFile('/etc/passwd')
    assert( data.isKindOfClass(NSData) )
    assert_equal( src.size, data.length )
    assert_kind_of( ObjcPtr, data.bytes )
  end

  def test_s_dataWithContentsOfURL
    fpath = '/System/Library/Frameworks/Cocoa.framework/Resources/Info.plist'
    unless File.exist? fpath # 10.6 or earlier
      fpath = '/System/Library/Frameworks/Cocoa.framework/Headers/Cocoa.h'
    end
    src = File.open(fpath).read
    url = NSURL.URLWithString "file://#{fpath}"
    data = NSData.dataWithContentsOfURL( url )
    assert( data.isKindOfClass(NSData) )
    assert_equal( src.size, data.length )
    assert_kind_of( ObjcPtr, data.bytes )
  end

  def test_s_dataWithData
    src = 'hello world'
    srcdata = NSData.dataWithBytes_length( src )
    data = NSData.dataWithData( srcdata )
    assert( data.isKindOfClass(NSData) )
    assert_equal( src.size, data.length )
    assert_kind_of( ObjcPtr, data.bytes )
  end

  def test_s_dataWithRubyString
    verbose_bak = $VERBOSE
    begin
      $VERBOSE = nil # suppress warning "deprecated"
      src = 'hello world'
      data = NSData.dataWithRubyString( src )
      assert( data.isKindOfClass(NSData) )
      assert_equal( src.size, data.length )
      assert_kind_of( ObjcPtr, data.bytes )
    ensure
      $VERBOSE = verbose_bak
    end
  end

  def test_length
    src = 'hello world'
    data = src.to_ns.dataUsingEncoding(OSX::NSASCIIStringEncoding)
    if RUBY_VERSION >= '2.0'
      assert_equal( src.bytesize, data.length )
    else
      assert_equal( src.size, data.length )
    end
    src = 'ハロー、ワールド' # UTF8, not ASCII characters
    data = src.to_ns.dataUsingEncoding(OSX::NSUTF8StringEncoding)
    if RUBY_VERSION >= '2.0'
      assert_equal( src.bytesize, data.length )
    else
      assert_equal( src.size, data.length )
    end
  end

  def test_bytes
    src = 'hello world'
    data = src.to_ns.dataUsingEncoding(OSX::NSASCIIStringEncoding)
    bstr = data.bytes.bytestr( src.size )
    if RUBY_VERSION >= '2.0'
      assert_equal(Encoding::ASCII_8BIT, bstr.encoding)
    end
    assert_equal( src, bstr )
    assert( data.bytes.tainted? )
  end

  def test_getBytes_length
    src = 'hello world'
    data = src.to_ns.dataUsingEncoding(OSX::NSASCIIStringEncoding)
    cptr = ObjcPtr.new( src.size )
    data.getBytes_length( cptr )
    bstr = cptr.bytestr( src.size )
    if RUBY_VERSION >= '2.0'
      assert_equal(Encoding::ASCII_8BIT, bstr.encoding)
    end
    assert_equal( src, bstr )
    assert( cptr.tainted? )
  end

  # - (BOOL)isEqualToData:(NSData *)other;
  def test_isEqualToData
    src = 'hello world'
    srcdata = src.to_ns.dataUsingEncoding(OSX::NSASCIIStringEncoding)
    data = NSData.dataWithData( srcdata )
    assert( data.isEqualToData( srcdata ))
  end

  # - (NSData *)subdataWithRange:(NSRange)range;
  def test_subdataWithRange
    src = 'hello world'
    data = src.to_ns.dataUsingEncoding(OSX::NSASCIIStringEncoding)
    subdata = data.subdataWithRange( 3..8 )
    assert_equal( 8 - 3 + 1, subdata.length )
  end

# - (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
# - (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically; // the atomically flag is ignored if the url is not of a type the supports atomic writes

# - (void *)mutableBytes;
# - (void)setLength:(unsigned)length;

# - (void)appendBytes:(const void *)bytes length:(unsigned)length;
# - (void)appendData:(NSData *)other;
# - (void)increaseLengthBy:(unsigned)extraLength;
# - (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)bytes;
# - (void)resetBytesInRange:(NSRange)range;
# - (void)setData:(NSData *)data;
# #if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED
# - (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)replacementBytes length:(unsigned)replacementLength;

end
