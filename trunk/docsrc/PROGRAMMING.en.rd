# -*-rd-*-
= RubyCocoa Programming

== INDEX

* ((<irb - Interactive Ruby>))
* ((<load libraries>))
* ((<an example the action with feeling>))
* ((<Cocoa class>))
* ((<create a Cocoa object>))
* ((<onwership and memory management>))
* ((<return value of method>))
* ((<A decision and a variation of method name>))
* ((<convert Ruby object argument of method as possible>))
* ((<method name prefix "oc_" - using this when method name conflict>))
* ((<inherited class and its instance of a Cocoa class>))
* ((<definition of a Cocoa inherited class>))
* ((<outlet>))
* ((<override of a method>))
* ((<create an instance of a Cocoa inherited class>))
* ((<Where should an initialization code be written?>))
* ((<Debugging of a RubyCocoa application>))


== irb - Interactive Ruby

It may be good to use "irb" for trying script snippet in this
document. It is a command to use a Ruby interpreter as interactively
in command line. launch following:

  % irb -r osx/cocoa

(NOTE) In Mac OS X 10.1, using both "irb" and RubyCocoa often is
occured Bus Error. recommend Mac OS X 10.2.


== load libraries

  require 'osx/cocoa'      # classes defined in Foundation and AppKit.

or

  require 'osx/foundation' # classes defined in Foundation
  require 'osx/appkit'     # classes defined in AppKit


== an example the action with feeling

At first it is a simple example to can taste the actual feeling that
changed (a sound sounds). try this with "irb":

  include OSX
  files = `ls /System/Library/Sounds/*.aiff`.split
  NSSound.alloc.initWithContentsOfFile_byReference (files[0], true).play
  NSSound.alloc.initWithContentsOfFile_byReference (files[1], true).play
  NSSound.alloc.initWithContentsOfFile_byReference (files[2], true).play

Below, the right side of "# =>" is character string done standard
output of as an execution result in description.


== Cocoa class

  p OSX::NSObject # => OSX::NSObject
  nsstr = OSX::NSObject.description
  p nsstr         # => #<OSX::OCObject:0x5194e8 class='NSCFString' id=A97910>
  nsobj = OSX::NSObject.alloc.init
  p nsobj         # => #<OSX::NSObject:0x51f5b4 class='NSObject' id=976D90>

In RubyCocoa, a Cocoa class is defined as a Ruby's Class under OSX
module (after 0.2.0). A Cocoa class is a Ruby's Class and behaves as
object of Cocoa.


== create a Cocoa object

The method of Cocoa is used for creation of a Cocoa object as it is.

  obj = OSX::NSObject.alloc.init
  str = OSX::NSString.stringWithString "hello"
  str = OSX::NSString.alloc.initWithString "world"

The created Cocoa object is wrapped in the object of a class called
OSX::ObjcID inside RubyCocoa. Usually, You don't need to be conscious
of existence of an OSX::ObjcID class.


== onwership and memory management

The instance of OSX::ObjcID surely has the ownership of the Cocoa
object which self has wrapped. Ownership is automatically lost, when
the instance of OSX::ObjcID is cleaned by GC. Therefore, it is not
necessary to care about memory management of ownership etc. in
RubyCocoa.

  str = OSX::NSObject.stringWithString "hello"
  str = OSX::NSObject.alloc.initWithString "world"

Although the two above-mentioned lines have difference whether
ownership is generated or it carries out, in Objective-C, there is no
necessity that he is conscious of ownership. In RubyCocoa, there is no
difference so much. It is not necessary to call methods, such as
release, autorelease, and retain, fundamentally, and you do not need
to make NSAutoreleasePool.

* use Cocoa method for creating a Cocoa object
* don't worry ownership and memory management.


== return value of method

  nstr = OSX::NSString.description
  p nstr      # => #<OCObject:0x7233e class='NSCFString' id=687610>
  p nstr.to_s # => "NSString"

  nstr = OSX::NSString.stringWithString "Hello World !"
  p nstr      # => #<OCObject:0x71970 class='NSCFString' id=688E90>
  p nstr.to_s # => "Hello World !"

  nstr = OSX::NSString.stringWithString(`pwd`.chop)
  nary = nstr.pathComponents
  p nary      # => #<OCObject:0x6bb2e class='NSCFArray' id=3C0150>

  ary = nary.to_a
  p ary       # => [#<OCObject:0x6a9b8 class='NSCFString' id=3C2B50>,...]

  ary.map! {|i| i.to_s }
  p ary       # => ["/", "Users", "hisa", "src", "ruby", "osxobjc"]

In RubyCocoa, the method which returns Objective-C objects, such as
NSString and NSArray, is returned as a Cocoa object so that it can
guess from these examples. It does not change into the object to which
Ruby corresponds positively (for example, String etc.). For a NSString
and NSArray, "to_s" and "to_a" is defined, it can be used.


== A decision and a variation of method name

  # play system sounds (2)
  sndfiles.each do |path|
    snd = OSX::NSSound.alloc.initWithContentsOfFile(path, :byReference, true)
    snd.play
    sleep 0.25 while snd.isPlaying?
  end

This is another version of "playing system sounds". This show the
other way of representation Objective-C Message Selector in Ruby
world.

As Objective-C:

  [obj hogeAt: a0 withParamA: a1 withParamB: a2]

The RubyCocoa prepare some message sending way. Most basic way is
substitute ":" with "_".

  obj.hogeAt_withParamA_withParamB_ (a0, a1, a2)

But this appearance is too bad, so you can omit the last "_".

  obj.hogeAt_withParamA_withParamB (a0, a1, a2)

When method name is very long, the relation Message Selector Keyword
and each arguments is unclear. In order to improve this 

  obj.hogeAt (a0, :withParamA, a1, :withParamB, a2)


For the method returned BOOL (predicate method), using method name
suffix "?".  If nothing this, method will return value 0(NO) or
1(YES). These values behave as the true in the Ruby World.

  nary = OSX::NSMutableArray.alloc.init
  p nary.containsObject("hoge")   # => 0
  p nary.containsObject?("hoge")  # => false
  nary.addObject("hoge")
  p nary.containsObject("hoge")   # => 1
  p nary.containsObject?("hoge")  # => true


== convert Ruby object argument of method as possible

It seems to be usual containsObject of the top and, in case of method
to catch Objective-C object as a value of argument, tries conversion
even if it just hands Ruby object so long as it is possible.


== method name prefix "oc_" - using this when method name conflict

  klass = OSX::NSObject.class
  p klass     # => OSX::OCObject
  klass = OSX::NSObject.oc_class
  p klass     # => #<OCObject:0x82f22 class='NSObject' id=80819B0C>

When the case same method name in Ruby and Objective-C like
"Object#class", use method name prefix "oc_".

== inherited class and its instance of a Cocoa class

The topic about the existing Cocoa class and its instance was treated
so far. From here, the topic about the definition of the Cocoa
inherited class which is needed when writing RubyCocoa application, or
its instance is treated. Since the implementation is tricky a little ,
although the inherited class of Cocoa has some restrictions and
peculiarities, let's see also including it.


== definition of a Cocoa inherited class

The class of the Cocoa object set up in the GUI definition file (nib
file) created by Interface Builder etc. is defined as an inherited
class (after 0.2.0). For example, the controller of a MVC model which
comes out to the first direction by a primer, a tutorial, etc. of
Cocoa is defined like ...

  class AppController < OSX::NSObject

    ib_outlets :messageField

    def btnClicked(sender)
      @messageField.setStringValue "Merry Xmas !"
    end

  end

The inherited class definition of Cocoa in RubyCocoa is similarly
described to be the inherited class definition by the usual Ruby in
this way.


== outlet

The outlet set as the class in the nib file is written to be:

  ns_outlets :rateField, :dollerField

in the definition of an inherited class. In fact, ns_outlets is the
same as Module#attr_writer. Therefore, a definition can also be
instead given like:

  def rateField= (new_val)
    @rateField = new_val
  end

ns_outlets has also an alias called ib_outlets.


== override of a method

When overriding the method defined by the parent class, it is
necessary to declare having overridden using ns_overrides (alias
ib_overrides).

  class MyCustomView < OSX::NSView

    ns_overrides :drawRect_, 'mouseUp:'

    def drawRect(frame)
    end

    ...
  end

In the argument of ns_overrides what expressed the message selector of
Objective-C as the string or the symbol is given. However, the
notation for omitting ":" and "_" of the end explained previously
cannot be used. It is necessary to describe correctly according to the
number of arguments.

For invocation of the same method of a super class in the definition
of a override method, it is to a method name. "super_" prefix is
attached and called.

  class MyCustomView < OSX::NSView

    ns_overrides :drawRect_

    def drawRect (frame)
      p frame
      super_drawRect(frame)   # invoke the implement of NSView#drawRect
    end

  end


== create an instance of a Cocoa inherited class

When the instance of a Cocoa inherited class needs to be created in a
Ruby script, it writes like:

  AppController.alloc.init  # use this

like the case of the existing Cocoa class. The most general way of
writing in Ruby:

  AppController.new    # don't use this

cannot be used (it is made to raise the exception). Although there are
various situations in this, since it becomes long, detailed
explanation is omitted here.

These restrictions have deep relation in instance generation being
performed in the turn:

  * alloc (in Objective-C world)
  * in alloc, create a Ruby object (initialize method is called here)


== Where should an initialization code be written?

Although the code of initialization is generally written into an
"initialize" method by Ruby, if it says in which, I will seldom be
recommended by the Cocoa inherited class. A reason is not initialized
only by a memory being assigned as a Cocoa object at the time by the
timing which the initialize method at the time of the instance
generation described previously is called. However, it is thought that
especially a problem is not generated in the limitation which does not
call the Cocoa side method.

In the case so that it may be loaded from a nib file initializing by
the "awakeFromNib" method is safest. Doesn't that it is also necessary
to actually define the inherited class of Cocoa have most these cases?

In the case of others, it is in the style of Cocoa "init" Probably,
writing to a method with a prefix will be good. Please do not forget
for a method to return "self".


== Debugging of a RubyCocoa application

Currently (2003-01-05), it is impossible that you use a ruby debugger
in ProjectBuilder, because a plug-in module for a RubyCocoa
application doesn't exist.

But, you can debug with a debugger (e.g. debug.rb) by launching a
application with appropriate options on shell. If you like Emacs, you
can use as well a command 'rubydb' which is contained in a ruby source
distribution.

The following shows a sequence that the debugger breaks execution of
a RubyCocoa application (simpleapp in samples).

  $ cd sample/simpleapp/
  $ pbxbuild
  $ build/SimpleApp.app/Contents/MacOS/SimpleApp -r debug
  (rdb:1) b AppController.rb:24    # set a break point
  Set breakpoint 1 at AppController.rb:24
  (rdb:1) c
  Breakpoint 1, aboutApp at AppController.rb:24
  AppController.rb:24:
  (rdb:1) l
  [19, 28] in AppController.rb
     19      @myView.set_alpha(@slider.floatValue)
     20      @myView.set_color(@colorWell.color)
     21    end
     22  
     23    def aboutApp (sender)
  => 24      NSApp().orderFrontStandardAboutPanelWithOptions(
     25        "Copyright" => "RubyCocoa #{RUBYCOCOA_VERSION}",
     26        "ApplicationVersion" => "Ruby #{VERSION}")
     27    end
     28  
     29    def colorBtnClicked (sender)
  (rdb:1) sender
  #<OSX::NSMenuItem:0xd439e class='NSMenuItem' id=0x3e27d0>
  (rdb:1) q
  Really quit? (y/n) y


$Date$
