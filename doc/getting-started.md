# @title Getting Started

Getting Started
===============

## Mac OS X built-in framework

Mac OS X 10.5 Leopard or later, RubyCocoa is installed as a part of Mac OS X.
The versions of RubyCocoa pre-installed into Mac OS X are:

* OS X 10.9 Mavericks: 1.0.1
* OS X 10.8 Mountain Lion: 1.0.1
* Mac OS X 10.7 Lion: 1.0.0
* Mac OS X 10.6 Snow Leopard: 1.0.0
* Mac OS X 10.5 Leopard: 0.13.2

If you want to use the latest RubyCocoa, you need to install RubyCocoa.framework from dmg or source code.

## Download binary distribution

Download RubyCocoa-x.x.x.dmg from [GitHub.com/rubycocoa/rubycocoa/releases](https://github.com/rubycocoa/rubycocoa/releases).

It includes library, samples, templates for Xcode etc. for RubyCocoa. Everything necessary for execution and development is included in an easy-to-install '.pkg' package file.

A successful installation of the binary package will add the following items:

- /Library/Frameworks/RubyCocoa.framework : RubyCocoa framework (core)
- inside of /Library/Ruby/Site/1.8/osx : RubyCocoa library (stub)
- /Library/Ruby/Site/1.8/universal-darwin12.0/rubycocoa.bundle : RubyCocoa extended library (stub)
- /Developer/Examples/RubyCocoa : Sample programs

After installation, try the samples that are written in Ruby. Refer to {file:try-samples.md Try Samples}.

## Install Xcode4 project templates (1.0.5 or later)

    $ ruby /Developer/Documentation/RubyCocoa/Templates/install_templates.rb \
          Xcode4.x
    % ls ~/Library/Developer/Xcode/Templates/Project\ Templates/Mac/Application
    Ruby-Cocoa Application Base.xctemplate
    Ruby-Cocoa Application.xctemplate
    Ruby-Cocoa Document-based Application.xctemplate
    Ruby-Core Data Application.xctemplate
    Ruby-Core Data Spotlight Application.xctemplate
    % ruby /Developer/Documentation/RubyCocoa/Templates/install_templates.rb \
          --help
    usage: install_templates.rb [options] TEMPLATE_DIR
        TEMPLATE_DIR: Xcode4.x or Xcode4.1
        -f, --force                      overwrite existing templates
        -v, --verbose                    print verbose message
            --dest=dir                   specify install destination

## Build from Source

Extract RubyCocoa source from the '.tar.gz' file into a directory somewhere.

    $ tar xzf RubyCocoa-x.x.x.tar.gz
    $ cd RubyCocoa-x.x.x
    $ ruby install.rb config
    $ ruby install.rb setup
    $ ruby install.rb test
    $ sudo ruby install.rb intstall

