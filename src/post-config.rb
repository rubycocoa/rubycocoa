def libruby_installed?
  /ld.*Undefined\s+symbols/ =~ `cc -framework LibRuby`
end

unless libruby_installed? then
  print <<MSG_DEFINE
!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!! begin Note !!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!
if "LibRuby.framework" is not installed, require install it before
execute setup. type:

  % ruby tool/install-libruby-frmwk.rb  # install to /Library/Frameworks
      or
  % ruby tool/install-libruby-frmwk.rb {anywhere}  # install to anywhere
MSG_DEFINE
end
