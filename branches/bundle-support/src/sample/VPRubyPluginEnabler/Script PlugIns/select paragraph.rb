vp_script( :superMenuTitle => "R Select",
           :menuTitle      => "R Current Paragraph",
           :shortcutKey    => 'o',
           :shortcutMask   => [ :command, :control ] ) do |windowController|

  windowController.textView.selectParagraph(nil)

end
