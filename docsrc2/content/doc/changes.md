
# RubyCocoa Changes

## changes 1.0.4 from 1.0.3: 2012-08-27

### fixes

  * fixed leaks at initializing rubycocoa-1.0.3.
  * fixed rubycocoa does not load bridgesupport files under nested framework,
    such as "quartzcore.framework/frameworks/coreimage.framework".


## changes 1.0.3 from 1.0.2: 2012-08-26 (not released)

### improvements

  * turn on debug printing by environment rubycocoa_debug.
  * project templates for xcode 4.x. [experimental]
    templates should be installed under ~/library/developer/xcode/templates.
    you can try the templates with the following command.

        $ svn export --force \
          https://rubycocoa.svn.sourceforge.net/svnroot/rubycocoa/trunk/src/template/xcode4.x/templates \
          ~/library/developer/xcode/templates


### fixes

  * fixed rubycocoa apps fail to launch by xcode-4 "run" with an error
    "invalid option -n (-h will show valid options)".
    now rubycocoa apps do not process commandline options such as "-d".

    if you want to avoid this problem with lion built-in rubycocoa,
    edit main.m and rb_main.rb in your project like this.

        diff -ur old/main.m new/main.m
        --- old/main.m  2011-11-19 15:49:58.000000000 +0900
        +++ new/main.m  2011-11-19 15:49:16.000000000 +0900
        @@ -11,5 +11,6 @@
         
         int main(int argc, const char *argv[])
         {
        -    return rbapplicationmain("rb_main.rb", argc, argv);
        +    rbapplicationinit("rb_main.rb", argc, argv, nil);
        +    return nsapplicationmain(argc, argv);
         }
        diff -ur old/rb_main.rb new/rb_main.rb
        --- old/rb_main.rb      2011-11-19 15:49:58.000000000 +0900
        +++ new/rb_main.rb      2011-11-19 15:49:16.000000000 +0900
        @@ -17,7 +17,4 @@
           end
         end
         
        -if $0 == __file__ then
        -  rb_main_init
        -  osx.nsapplicationmain(0, nil)
        -end
        +rb_main_init

    the api rbapplicationinit() is available since version 0.12.0.
    (version of leopard built-in rubycocoa is 0.13.x)

  * fixed nsbundle.loadnibnamed_owner(nibname, owner) fails on lion or later.

## changes 1.0.2 from 1.0.1: 2011-08-31

### improvements

  * osx.load_plist() accepts binary format plist data.

### fixes

  * lion
     * fixed segv at working with nsdata or ruby byte string.
     * fixed some opaque becomes abrecordref.
     * fixed build error with install.rb.
  * x86_64
     * fixed segv passing/getting small c struct contains c array,
       such as nsdecimal.

## changes 1.0.1 from 1.0.0: 2009-10-18

### improvements

  * rubycocoa.framework built for 10.5 works on 10.6

        $ ruby install.rb config \
               --macosx-deployment-target=10.5 \
               --sdkroot=/developer/sdks/macosx10.5.sdk \
               --target-archs="ppc i386"
        $ ruby install.rb setup

  * nsstring for same string returns same hash in ruby world.
    it enables nsstring to become a key of hash.

        str1 = osx::nsstring.alloc.initwithstring("a")
        str2 = osx::nsstring.alloc.initwithstring("a")
        hash = {}
        hash[str1] = 1
        hash[str2] = 2
        p hash[str1] # => 2

  * refactoring build system for universal binary
     * deprecate config option "--build-universal"
     * introduce config option "--target-archs"

           old) ruby install.rb config --build-universal=yes
           new) ruby install.rb config --target-archs="i386 x86_64 ppc"

  * upgrade project templates for xcode 3.x

### fixes

  * snow leopard
     * fixed application stops with errors for thread such as
       "assertion failed: (ctx->autoreleasepool ..."
     * fixed some errors of invocation-based undo with nsundomanager
  * x86_64
     * correct value of osx::nsnotfound (foudation.bridgesupport is wrong)
     * fixed debug log sometimes prints incorrect integer values
     * fixed getting values for 64-bit from bridgesupport files
  * others
     * fixed segv irb at `require "osx/cocoa"'

