# -*-rd-*-

== What is RubyCocoa ?

RubyCocoa is a framework for ((<Mac OS X|URL:http://www.apple.com/macosx/>))
that allows ((<Cocoa|URL:http://developer.apple.com/cocoa/>)) programming
in the object-oriented scripting language ((<Ruby|URL:http://www.ruby-lang.org/>)).

RubyCocoa lets you write a Cocoa application in Ruby. It allows you to create
and use a Cocoa object in a Ruby script. It's possible to write a
Cocoa application that mixes Ruby and Objective-C code.

Some useful applications of RubyCocoa:

  * Exploration of a Cocoa object's features with (({irb})) interactively
  * Prototyping of a Cocoa application
  * Writing a Cocoa application that combines good features of Ruby and Objective-C
  * Wrapping Mac OS X's native GUI for a Ruby script


== Screenshot

The following screenshot is of a RubyCocoa application which consists of only
Ruby scripts and a nib file created in Mac OS X's Interface Builder.
<<< img_simpleapp


== Script Examples

The next script plays all the system sounds.

  require 'osx/cocoa'
  snd_files =`ls /System/Library/Sounds/*.aiff`.split
  snd_files.each do |path|
    snd = OSX::NSSound.alloc.
      initWithContentsOfFile_byReference (path, true)
    snd.play
    sleep 0.5
  end

The following examples are scripts that read a text aloud.
(for OS X 10.2 or later)

  require 'osx/cocoa'
  include OSX
  def speak (str)
    str.gsub! (/"/, '\"')
    src = %(say "#{str}")
    NSAppleScript.alloc.initWithSource(src).executeAndReturnError(nil)
  end
  speak "Hello World!"
  speak "Kon nich Wah. Ogan key desu ka?" # "Hi. How are you." in Japanese

The next script is a class definition that connects to a nib file created in
Interface Builder.

  require 'osx/cocoa'

  class AppCtrl < OSX::NSObject

    ib_outlets :monthField, :dayField, :mulField

    def awakeFromNib
      @monthField.setIntValue  Time.now.month
      @dayField.setIntValue Time.now.day
      convert
    end

    def convert (sender = nil)
      val = @monthField.intValue * @dayField.intValue
      @mulField.setIntValue (val)
      @monthField.selectText (self)
    end

    def windowShouldClose (sender = nil)
      OSX.NSApp.stop (self)
      true
    end

  end


== LICENSE

((<GNU Lesser General Public License version 2. LGPL
|URL:http://www.gnu.org/licenses/lgpl.html>)),
or the Ruby License.


== History

[2001(fall)] Fujimoto Hisa implemented a ruby extend module to wrap NSObject and NSClassFromString.
[2001.10] integrated with InterfaceBuilder and ProjectBuilder.
[2001.11] 1st RubyCocoa was released.
[2002.2(about)] registered a project to SourceForge (((<URL:http://sourceforge.net/projects/rubycocoa>))). Chris Thomas joined the commiters.
[2002.5] On ((<'Dr. Dobbs Journal, May 2002'|URL:http://www.ddj.com/articles/2002/0205/>)), the article about RubyCocoa "Examining RubyCocoa" by Chris Thomas.
[2003] Kimura Wataru joined the commiters.
[2006.2] Jonathan Paisley joined the commiters.
[2006] RubyCocoa resource site ((<rubycocoa.com|URL:http://www.rubycocoa.com/>)) by Tim Burks.
[2006.5] Laurent Sansonetti joined the commiters.
[2006.8] Tim Burks joined the commiters.
[2006.8] RubyCocoa will be included in Leopard at Apple WWDC.


== Contact

* ((<URL:http://sourcefore.net/projects/rubycocoa/>)) (will be move to ((<URL:http://www.macosforge.org/>)))
* RubyCocoa Project <hisa at sourceforge.net> (will be move to mac os forge account)



$Date$
