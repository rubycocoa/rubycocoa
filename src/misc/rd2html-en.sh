#!/bin/sh

HTML_CHARSET=us-ascii
HTML_LANG=en
HTML_CSS=rdtext.css

rd2 -r rd/rd2html-lib --with-css=$HTML_CSS --html-charset=$HTML_CHARSET --html-lang=$HTML_LANG $@
