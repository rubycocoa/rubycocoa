#!/bin/sh

RUBY=`which ruby`
RUNTEST=`which runtest.rb`

if [ -f alltest.sh ]; then
    RELPATH=..
    TARGET=test*.rb
elif [ -f framework/RubyCocoa.h ]; then
    RELPATH=.
    TARGET=tests/test_*.rb
else
    echo 'usage: cd {rubycocoa_src_dir}/tests && sh alltest.sh'
    exit 1
fi

$RUBY -I$RELPATH/lib -I$RELPATH/ext $RUNTEST $TARGET
