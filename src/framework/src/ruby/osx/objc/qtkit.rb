#
# Version 1.0 2006-10-31
# Created and maintained by Eloy Duran <eloy.de.enige@gmail.com>

require 'osx/cocoa'

class String
  QTTIME_STRING = '(\d+)(:)(\d+)(:)(\d+)(:)(\d+)(.)(\d+)(\/)(\d+)'
  
  def to_qttime
    # This method implements (QTTime.h): QTKIT_EXTERN QTTime QTTimeFromString(NSString* string)
    # days:hours:minutes:seconds:frames/timescale    
    timecode_parsed = self.scan(Regexp.new(QTTIME_STRING)).flatten
    unless timecode_parsed.empty?
      # days in ms
      time_value  = timecode_parsed[0].to_i * 86400000
      # hours in ms
      time_value += timecode_parsed[2].to_i * 3600000      
      # minutes in ms
      time_value += timecode_parsed[4].to_i * 60000      
      # seconds in ms
      time_value += timecode_parsed[6].to_i * 1000

      # now convert miliseconds to timeValue/timeScale
      time_value = (time_value.to_f / 1000) * (timecode_parsed[10].to_f)
      # and add the remaining frames to the total
      time_value += timecode_parsed[8].to_f
      
      # Make the time_value negative if the string respresents a negative timecode
      time_value = -time_value if self.include?('-')
      return OSX::QTKit::QTTime.new(time_value.round, timecode_parsed[10])
    else
      nil
    end        
  end
  
  def to_qttime_r
    # This method implements (QTTimeRange.h): QTKIT_EXTERN QTTimeRange QTTimeRangeFromString(NSString* string)
    qttime_a, qttime_b = self.split('~').collect {|range| range.to_qttime }
    return OSX::QTKit::QTTimeRange.new(qttime_a, qttime_b)
  end
  
end

module OSX
  
  module QTKit

    class QTTime
      attr_accessor :timeValue, :timeScale, :flags

      def initialize(*args)
        args.flatten!
        unless args.empty?
          @timeValue = args[0].to_i
          @timeScale = args[1].to_i
          # Asked about the flags variable on the quicktime-api list.
          # Tim Monroe from apple quicktime engineering said
          # that it can just be set to 0.
          # The only time that this flag is used, is when specifying a indefinite time.
          unless args[2].nil?
            @flags   = args[2].to_i
          else
            @flags   = 0
          end
        else
          @timeValue = 0
          @timeScale = 600
          @flags     = 0
        end
      end

      def indefinite?
        # This method implements (QTTime.h): QTKIT_EXTERN BOOL QTTimeIsIndefinite(QTTime time)
        if @flags == KQTTimeIsIndefinite then
          return true
        else
          return false
        end
      end

      def timeValue_in_scale(new_timeScale)
        # Return the recalculated timeValue in a different scale
        # Always round the float up to a integer:
        # http://lists.apple.com/archives/QuickTime-API/2006//Oct/msg00240.html
        ((@timeValue.to_f / @timeScale.to_f) * new_timeScale.to_f).ceil
      end

      def to_scale(new_timeScale)
        # This method implements (QTTime.h): QTKIT_EXTERN QTTime QTMakeTimeScaled(QTTime time, long timeScale)
        return QTTime.new(self.timeValue_in_scale(new_timeScale), new_timeScale)
      end

      def +(other)
        # This method implements (QTTime.h): QTKIT_EXTERN QTTime QTTimeIncrement(QTTime time, QTTime increment)
        if other.timeScale > @timeScale then
          new_timeValue = self.timeValue_in_scale(other.timeScale) + other.timeValue
          return QTTime.new(new_timeValue, other.timeScale)
        else
          new_timeValue = other.timeValue_in_scale(@timeScale) + @timeValue
          return QTTime.new(new_timeValue, @timeScale)
        end
      end

      def -(other)
        # This method implements (QTTime.h): QTKIT_EXTERN QTTime QTTimeDecrement(QTTime time, QTTime decrement)
        if other.timeScale > @timeScale then
          new_timeValue = self.timeValue_in_scale(other.timeScale) - other.timeValue
          return QTTime.new(new_timeValue, other.timeScale)
        else
          new_timeValue = @timeValue - other.timeValue_in_scale(@timeScale)
          return QTTime.new(new_timeValue, @timeScale)
        end
      end

      def to_s
        # This method implements (QTTime.h): QTKIT_EXTERN NSString* QTStringFromTime(QTTime time)
        # days:hours:minutes:seconds:frames/timescale

        # calculate the total ms in @timeValue (always positive)
        time_value_in_ms = ((@timeValue.abs.to_f / @timeScale.to_f) * 1000).to_i
        
        # the rest calculates how much will fit in the subsequent remainder
        days = time_value_in_ms - time_value_in_ms.modulo(86400000) # days
        hours = (time_value_in_ms - days) - time_value_in_ms.modulo(3600000) #hours
        minutes = (time_value_in_ms - (days + hours)) - time_value_in_ms.modulo(60000) # minutes
        seconds = (time_value_in_ms - (days + hours + minutes)) - time_value_in_ms.modulo(1000) # seconds
        frames = time_value_in_ms - (days + hours + minutes + seconds) # frames
        
        # Now we need to devide the variables, because we still have it in ms
        days    = days    / 86400000
        hours   = hours   / 3600000
        minutes = minutes / 60000
        seconds = seconds / 1000
        frames  = ((frames.to_f * @timeScale.to_f) / 1000).round
        
        # Return the formatted timecode
        positive_or_negative = (@timeValue < 0) ? '-' : ''
        return positive_or_negative << format("%01d:%02d:%02d:%02d.%02d/%d", days, hours, minutes, seconds, frames, @timeScale)
      end

      def to_a
        [ @timeValue, @timeScale, @flags ]
      end

      def ==(other)
        @timeValue == other.timeValue and @timeScale == other.timeScale and @flags == other.flags
      end
      
      include Comparable
      def <=>(other)
        if other.timeScale > @timeScale
          self.to_scale(other.timeScale).timeValue <=> other.timeValue
        else
          @timeValue <=> other.to_scale(@timeScale).timeValue
        end
      end
    end
    # These are all the functions that the QTKit provide to work with QTTime structures.
    def QTMakeTime(*args);                           QTTime.new(*args);                  end
    def QTMakeTimeScaled(qttime_obj, new_timeScale); qttime_obj.to_scale(new_timeScale); end
    def QTStringFromTime(qttime_obj);                qttime_obj.to_s;                    end
    def QTTimeFromString(string_obj);                string_obj.to_qttime;               end
    def QTTimeIsIndefinite(qttime_obj);              qttime_obj.indefinite?;             end
    def QTTimeIncrement(qttime_obj_a, qttime_obj_b); qttime_obj_a + qttime_obj_b;        end
    def QTTimeDecrement(qttime_obj_a, qttime_obj_b); qttime_obj_a - qttime_obj_b;        end
    
    class QTTimeRange
      attr_accessor :time, :duration

      def initialize(*args)
        if args.size == 2 then
          @time     = QTTime.new(args[0].to_a)
          @duration = QTTime.new(args[1].to_a)
        elsif args.size == 6 then
          @time     = QTTime.new(args[0..2])
          @duration = QTTime.new(args[3..5])
        else
          @time     = QTTime.new()
          @duration = QTTime.new()
        end
      end

      def to_s
        # This method implements (QTTimeRange.h): QTKIT_EXTERN NSString* QTStringFromTimeRange(QTTimeRange range)
        "#{@time.to_s}~#{@duration.to_s}"
      end
      
      def to_a
        [ @time.to_a, @duration.to_a ].flatten
      end

      def ==(other)
        # This method implements (QTTimeRange.h): QTKIT_EXTERN BOOL QTEqualTimeRanges(QTTimeRange range, QTTimeRange range2)
        @time == other.time and @duration == other.duration
      end
      
      def total_duration
        if @time.timeValue > @duration.timeValue
          return @time.timeValue - @duration.timeValue
        else
          return @duration.timeValue - @time.timeValue
        end
      end
      
      def union(other)
        # This method implements (QTTimeRange.h): QTKIT_EXTERN QTTimeRange QTUnionTimeRange(QTTimeRange range1, QTTimeRange range2)
        self > other ? other : self
      end
      
      def intersection(other)
        # This method implements (QTTimeRange.h): QTKIT_EXTERN QTTimeRange QTIntersectionTimeRange(QTTimeRange range1, QTTimeRange range2)
        self < other ? other : self
      end
      
      def include?(qttime_obj)
        # This method implements (QTTimeRange.h): QTKIT_EXTERN BOOL QTTimeInTimeRange(QTTime time, QTTimeRange range)
        qttime_obj >= @time and qttime_obj <= @duration
      end
      
      def last
        # This method implements (QTTimeRange.h): QTKIT_EXTERN QTTime QTTimeRangeEnd(QTTimeRange range)
        return OSX::QTKit::QTTime.new((@time.timeValue + @duration.timeValue), @time.timeScale)
      end
      
      include Comparable
      def <=>(other)
        self.total_duration <=> other.total_duration
      end
    end
    # These are all the functions that the QTKit provide to work with QTTimeRange structures.
    def QTMakeTimeRange(*args);                                            QTTimeRange.new(*args);                              end
    def QTEqualTimeRanges(qttime_range_obj_a, qttime_range_obj_b);         qttime_range_obj_a == qttime_range_obj_b;            end 
    def QTStringFromTimeRange(qttime_range_obj);                           qttime_range_obj.to_s;                               end
    def QTTimeRangeFromString(string_obj);                                 string_obj.to_qttime_r;                              end
    def QTUnionTimeRange(qttime_range_obj_a, qttime_range_obj_b);          qttime_range_obj_a.union qttime_range_obj_b;         end
    def QTIntersectionTimeRange(qttime_range_obj_a, qttime_range_obj_b);   qttime_range_obj_a.intersection qttime_range_obj_b;  end
    def QTTimeInTimeRange(qttime_obj, qttime_range_obj);                   qttime_range_obj.include? qttime_obj;                end
    def QTTimeRangeEnd(qttime_range_obj);                                  qttime_range_obj.last;                               end
  end
  
end

module OSX
  # Load the QTKit.framework
  NSBundle.bundleWithPath('/System/Library/Frameworks/QTKit.framework').load

  # Import the obj-c side classes
  ns_import :QTDataReference
  ns_import :QTMedia
  ns_import :QTMovie
  ns_import :QTMovieView
  ns_import :QTTrack
  
  # Include our own RubyCocoa-side classes and methods
  include QTKit
  
  # Constants:
  
  # -- QTKit/QTMovie.h
  #
  #// constants for movieFileTypes method
  #typedef enum {...} QTMovieFileTypeOptions;
  QTIncludeStillImageTypes    = 1 << 0
  QTIncludeTranslatableTypes  = 1 << 1
  QTIncludeAggressiveTypes    = 1 << 2
  QTIncludeCommonTypes        = 0
  QTIncludeAllTypes           = 0xffff
  
  # -- QTKit/QTTime.h
  #
  KQTTimeIsIndefinite = 1 << 0
  QTZeroTime = OSX::QTKit::QTTime.new.freeze
  QTIndefiniteTime = OSX::QTKit::QTTime.new(0,0,KQTTimeIsIndefinite).freeze
  #
  #// constants for movieShouldContinueOp delegate method
  #typedef enum {...} QTMovieOperationPhase;
  # (Explained in 'Quicktime Constants Reference')
  QTMovieOperationBeginPhase         = 0
  QTMovieOperationUpdatePercentPhase = 1
  QTMovieOperationEndPhase           = 2
  
  # -- QTKit/QTUtilities.h
  #
  # FIXME: These are the only ones I haven't done, because I think you can just pass a string...
  #
  #  // helper functions
  # QTKIT_EXTERN NSString *QTStringForOSType (OSType type)
  # QTKIT_EXTERN OSType QTOSTypeForString (NSString *string)
  
  [
    # -- QTKit/QTDataReference.h - data handler types
    :QTDataReferenceTypeFile,
    :QTDataReferenceTypeHandle,
    :QTDataReferenceTypePointer,
    :QTDataReferenceTypeResource,
    :QTDataReferenceTypeURL,

    # -- QTKit/QTMedia.h - media types
    :QTMediaTypeVideo,
    :QTMediaTypeSound,
    :QTMediaTypeText,
    :QTMediaTypeBase,
    :QTMediaTypeMPEG,
    :QTMediaTypeMusic,
    :QTMediaTypeTimeCode,
    :QTMediaTypeSprite,
    :QTMediaTypeFlash,
    :QTMediaTypeMovie,
    :QTMediaTypeTween,
    :QTMediaType3D,
    :QTMediaTypeSkin,
    :QTMediaTypeQTVR,
    :QTMediaTypeHint,
    :QTMediaTypeStream,

    # -- QTKit/QTMedia.h - media characteristics
    :QTMediaCharacteristicVisual,
    :QTMediaCharacteristicAudio,
    :QTMediaCharacteristicCanSendVideo,
    :QTMediaCharacteristicProvidesActions,
    :QTMediaCharacteristicNonLinear,
    :QTMediaCharacteristicCanStep,
    :QTMediaCharacteristicHasNoDuration,
    :QTMediaCharacteristicHasSkinData,
    :QTMediaCharacteristicProvidesKeyFocus,
    :QTMediaCharacteristicHasVideoFrameRate,

    # -- QTKit/QTMedia.h - media attributes
    :QTMediaCreationTimeAttribute,      # NSDate
    :QTMediaDurationAttribute,          # NSValue (QTTime)
    :QTMediaModificationTimeAttribute,  # NSDate
    :QTMediaSampleCountAttribute,       # NSNumber (long)
    :QTMediaQualityAttribute,           # NSNumber (short)
    :QTMediaTimeScaleAttribute,         # NSNumber (long)
    :QTMediaTypeAttribute,              # NSString
    
    # -- QTKit/QTMovie.h - pasteboard support
    :QTMoviePasteboardType,

    # -- QTKit/QTMovie.h - notifications          description                         parameter   parameter type
    :QTMovieEditabilityDidChangeNotification,   # change in movie editability         -           -
    :QTMovieEditedNotification,                 # edit was done to the movie          -           -
    :QTMovieLoadStateDidChangeNotification,     # change in movie load state          -           -
    :QTMovieLoopModeDidChangeNotification,      # change in movie looping mode        -           -
    :QTMovieMessageStringPostedNotification,    # message string                      message     NSString
    :QTMovieRateDidChangeNotification,          # change in movie rate                rate        NSNumber (float)
    :QTMovieSelectionDidChangeNotification,     # change in selection start/duration  -           -
    :QTMovieSizeDidChangeNotification,          # change in movie size                -           -
    :QTMovieStatusStringPostedNotification,     # status string                       status      NSString
    :QTMovieTimeDidChangeNotification,          # goto time occured                   -           -
    :QTMovieVolumeDidChangeNotification,        # change in volume                    -           -
    :QTMovieDidEndNotification,                 # movie ended                         -           -
    :QTMovieChapterDidChangeNotification,       # change in current chapter           -           -
    :QTMovieChapterListDidChangeNotification,   # change in chapter list              -           -
    :QTMovieEnterFullScreenRequestNotification, # full screen playback requested      -           -
    :QTMovieExitFullScreenRequestNotification,  # normal windowed playback requested  -           -
    :QTMovieCloseWindowRequestNotification,     # window close requested              -           -

    # -- QTKit/QTMovie.h - notification parameters
    :QTMovieMessageNotificationParameter,
    :QTMovieRateDidChangeNotificationParameter,
    :QTMovieStatusFlagsNotificationParameter,
    :QTMovieStatusCodeNotificationParameter,
    :QTMovieStatusStringNotificationParameter,
    :QTMovieTargetIDNotificationParameter,
    :QTMovieTargetNameNotificationParameter,

    # -- QTKit/QTMovie.h - writeToFile: attributes dictionary keys
    :QTMovieExport,             # NSNumber (BOOL)
    :QTMovieExportType,         # NSNumber (long)
    :QTMovieFlatten,            # NSNumber (BOOL)
    :QTMovieExportSettings,     # NSData (QTAtomContainer)
    :QTMovieExportManufacturer, # NSNumber (long)

    # -- QTKit/QTMovie.h - addImage: attributes dictionary keys
    :QTAddImageCodecType,       # NSString
    :QTAddImageCodecQuality,    # NSNumber

    # -- QTKit/QTMovie.h - data locators for movieWithAttributes/initWithAttributes
    :QTMovieDataReferenceAttribute, # QTDataReference
    :QTMoviePasteboardAttribute,    # NSPasteboard
    :QTMovieDataAttribute,          # NSData

    # -- QTKit/QTMovie.h - movie instantiation options for movieWithAttributes/initWithAttributes
    :QTMovieFileOffsetAttribute,            # NSNumber (long long)
    :QTMovieResolveDataRefsAttribute,       # NSNumber (BOOL)
    :QTMovieAskUnresolvedDataRefsAttribute, # NSNumber (BOOL)
    :QTMovieOpenAsyncOKAttribute,           # NSNumber (BOOL)

    # -- QTKit/QTMovie.h - movie attributes
    :QTMovieActiveSegmentAttribute,             # NSValue (QTTimeRange)
    :QTMovieAutoAlternatesAttribute,            # NSNumber (BOOL)
    :QTMovieCopyrightAttribute,                 # NSString
    :QTMovieCreationTimeAttribute,              # NSDate
    :QTMovieCurrentSizeAttribute,               # NSValue (NSSize)
    :QTMovieCurrentTimeAttribute,               # NSValue (QTTime)
    :QTMovieDataSizeAttribute,                  # NSNumber (long long)
    :QTMovieDelegateAttribute,                  # NSObject
    :QTMovieDisplayNameAttribute,               # NSString
    :QTMovieDontInteractWithUserAttribute,      # NSNumber (BOOL)
    :QTMovieDurationAttribute,                  # NSValue (QTTime)
    :QTMovieEditableAttribute,                  # NSNumber (BOOL)
    :QTMovieFileNameAttribute,                  # NSString
    :QTMovieHasAudioAttribute,                  # NSNumber (BOOL)
    :QTMovieHasDurationAttribute,               # NSNumber (BOOL)
    :QTMovieHasVideoAttribute,                  # NSNumber (BOOL)
    :QTMovieIsActiveAttribute,                  # NSNumber (BOOL)
    :QTMovieIsInteractiveAttribute,             # NSNumber (BOOL)
    :QTMovieIsLinearAttribute,                  # NSNumber (BOOL)
    :QTMovieIsSteppableAttribute,               # NSNumber (BOOL)
    :QTMovieLoadStateAttribute,                 # NSNumber (long)
    :QTMovieLoopsAttribute,                     # NSNumber (BOOL)
    :QTMovieLoopsBackAndForthAttribute,         # NSNumber (BOOL)
    :QTMovieModificationTimeAttribute,          # NSDate
    :QTMovieMutedAttribute,                     # NSNumber (BOOL)
    :QTMovieNaturalSizeAttribute,               # NSValue (NSSize)
    :QTMoviePlaysAllFramesAttribute,            # NSNumber (BOOL)
    :QTMoviePlaysSelectionOnlyAttribute,        # NSNumber (BOOL)
    :QTMoviePosterTimeAttribute,                # NSValue (QTTime)
    :QTMoviePreferredMutedAttribute,            # NSNumber (BOOL)
    :QTMoviePreferredRateAttribute,             # NSNumber (float)
    :QTMoviePreferredVolumeAttribute,           # NSNumber (float)
    :QTMoviePreviewModeAttribute,               # NSNumber (BOOL)
    :QTMoviePreviewRangeAttribute,              # NSValue (QTTimeRange)
    :QTMovieRateAttribute,                      # NSNumber (float)
    :QTMovieSelectionAttribute,                 # NSValue (QTTimeRange)
    :QTMovieTimeScaleAttribute,                 # NSNumber (long)
    :QTMovieURLAttribute,                       # NSURL
    :QTMovieVolumeAttribute,                    # NSNumber (float)
    :QTMovieRateChangesPreservePitchAttribute,  # NSNumber (BOOL)

    # -- QTKit/QTMovie.h - exceptions
    :QTMovieUneditableException,
    
    # -- QTKit/QTMovieView.h - bindings
    :QTMovieViewMovieBinding,
    :QTMovieViewControllerVisibleBinding,
    :QTMovieViewPreservesAspectRatioBinding,
    :QTMovieViewFillColorBinding,
    
    # -- QTKit/QTTrack.h - track attributes
    :QTTrackBoundsAttribute,            # NSValue (NSRect)
    :QTTrackCreationTimeAttribute,      # NSDate
    :QTTrackDimensionsAttribute,        # NSValue (NSSize)
    :QTTrackDisplayNameAttribute,       # NSString
    :QTTrackEnabledAttribute,           # NSNumber (BOOL)
    :QTTrackIDAttribute,                # NSNumber (long)
    :QTTrackLayerAttribute,             # NSNumber (short)
    :QTTrackMediaTypeAttribute,         # NSString
    :QTTrackModificationTimeAttribute,  # NSDate
    :QTTrackRangeAttribute,             # NSValue (QTTimeRange)
    :QTTrackTimeScaleAttribute,         # NSNumber (long)
    :QTTrackUsageInMovieAttribute,      # NSNumber (BOOL)
    :QTTrackUsageInPosterAttribute,     # NSNumber (BOOL)
    :QTTrackUsageInPreviewAttribute,    # NSNumber (BOOL)
    :QTTrackVolumeAttribute             # NSNumber (float)

  ].each do |name|
    module_eval <<-EOE,__FILE__,__LINE__+1
        def #{name}
          objc_symbol_to_obj('#{name}', '@')
        end
        module_function :#{name}
      EOE
  end
  
end
