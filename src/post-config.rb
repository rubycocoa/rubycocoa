print <<MSG_DEFINE
!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!! begin Note !!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!
if "LibRuby.framework" is not installed, require install it before
execute setup. type:

  % ruby tool/mk_libruby_frmwk.rb  # install to /Library/Frameworks
      or
  % ruby tool/mk_libruby_frmwk.rb {anywhere}  # install to anywhere
MSG_DEFINE
