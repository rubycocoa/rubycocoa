# -*-rd-*-

== What is RubyCocoa ?

RubyCocoa is a framework for ((<Mac OS X|URL:http://www.apple.com/macosx/>))
that allows ((<Cocoa|URL:http://developer.apple.com/cocoa/>)) programming
in the object-oriented scripting language ((<Ruby|URL:http://www.ruby-lang.org/>)).

RubyCocoa allows you to write a Cocoa application in Ruby. It allows
you to create a Cocoa object in a Ruby script and to use it. In Cocoa
application, mixture of program written by both Ruby and Objective-C
is possible.

Some useful cases of RubyCocoa:

  * Exploration of a Cocoa object's feature with 'irb' interactively
  * Prototyping of a Cocoa application
  * Cocoa application that include good feature of Ruby and Objective-C
  * Wrapping Mac OS X native GUI for Ruby script


== Screenshot

This is ((<a screenshot|URL:http://www.imasy.or.jp/~hisa/mac/rubycocoa/simpleapp.jpg>)) 
of running a Cocoa application| that consists of only Ruby scripting and Interface
Builder's Nib file by RubyCocoa.


== Script Examples

Next script is playing system sounds.

  require 'osx/cocoa'
  snd_files =`ls /System/Library/Sounds/*.aiff`.split
  snd_files.each do |path|
    snd = OSX::NSSound.alloc.
      initWithContentsOfFile_byReference (path, true)
    snd.play
    sleep 0.5
  end

The following examples are scripts that Mac read a text aloud.
(for OSX 10.2)

  require 'osx/cocoa'
  include OSX
  def speak (str)
    str.gsub! (/"/, '\"')
    src = %(say "#{str}")
    NSAppleScript.alloc.initWithSource(src).executeAndReturnError(nil)
  end
  speak "Hello World!"
  speak "Kon nich Wah. Ogan key desu ka?" # "Hi. How are you." in Japanese

Next script is a class definition that is related with nib file made
by Interface Builder.

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


== LICENCE

((<GNU Lesser General Public License version 2. LGPL
|URL:http://www.gnu.org/licenses/lgpl.html>))


== ACKNOWLEDGEMENT

Special Thanks to Chris Thomas, Luc "lucsky" Heinrich and S.Sawada.

And thanks to:

Gesse Gam, Hiroyuki Shimura, Masaki Yatsu, Masatoshi Seki, Michael Miller, 
Ogino Junya, Ralph Broom, Rich Kilmer, Tetsuhumi Takaishi, Tosh
and more folks.


== Contact

Feel free to send comments, icon design, bug reports and patches about
RubyCocoa. I want to ask a kind English native to correct my strange
English writing. Thanks.

An author looks for job (an income source).  Is not there a supporter
(sponsor, investor or etc...) with interest into development of
RubyCocoa or other?

Contact ((<me|URL:mailto:contact.rubycocoa@fobj.com>)) freely please.


FUJIMOTO, Hisakuni <hisa@imasy.or.jp> $Date$
