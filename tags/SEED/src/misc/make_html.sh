#!/bin/sh

mkdir -p html
cp -f misc/rdtext.css html/
sh misc/rd2html-ja.sh --html-title=RubyOSXOBJC-MINITOUR doc/MINITOUR.ja > html/MINITOUR.ja.html
sh misc/rd2html-en.sh --html-title=RubyOSXOBJC-MINITOUR doc/MINITOUR.en > html/MINITOUR.en.html
sh misc/rd2html-ja.sh --html-title=RubyOSXOBJC-INSTALL ./INSTALL.ja > html/INSTALL.ja.html
sh misc/rd2html-en.sh --html-title=RubyOSXOBJC-INSTALL ./INSTALL.en > html/INSTALL.en.html
