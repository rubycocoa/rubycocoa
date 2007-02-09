vp_script( :superMenuTitle => "R Select",
           :menuTitle      => "R Current Line",
           :shortcutKey    => 'l',
           :shortcutMask   => [ :command, :control ] ) do |windowController|

  windowController.textView.selectLine(nil)

end
