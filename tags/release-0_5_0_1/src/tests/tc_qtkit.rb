#
#  $Id: /remote/trunk/src/tests/tc_attachments.rb 1224 2006-11-03T17:23:39.319167Z paisleyj  $
#
#  Copyright (c) 2006 Jonathan Paisley
#

require 'test/unit'
require 'osx/cocoa'
require 'osx/qtkit'

class TC_QTKit < Test::Unit::TestCase
  include OSX

  def test_String_to_qttime
    # days:hours:minutes:seconds.frames/timescale
    qtt = "1:2:3:5.7/1000".to_qttime
    millis = (((1 * 24 + 2) * 60 + 3) * 60 + 5) * 1000 + 7
    assert_equal millis, qtt.timeValue
    assert_equal 1000, qtt.timeScale
    
    assert_nil "1:2:3:5:7/1000".to_qttime
  end
  
  def test_String_to_qttime_r
    qtt1 = "1:2:3:5.7/1000"
    millis1 = (((1 * 24 + 2) * 60 + 3) * 60 + 5) * 1000 + 7
    qtt2 = "2:2:3:5.7/1000"
    millis2 = (((2 * 24 + 2) * 60 + 3) * 60 + 5) * 1000 + 7
    qttr = "#{qtt1}~#{qtt2}".to_qttime_r
    assert_equal millis1, qttr.time.timeValue
    assert_equal millis2, qttr.duration.timeValue
  end
  
  def test_qtkit_loaded
    # Just check that we don't get any exceptions here
    movie = QTMovie.movie
  end
  
  def test_qtkit_qttime_passing
    movie = QTMovie.movie
    movie.setCurrentTime("1:2:3:5.7/1000".to_qttime)
  end

end
