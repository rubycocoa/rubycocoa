vp_script( :menuTitle      => "R New Page With Current Date",
           :shortcutKey    => 'j',
           :shortcutMask   => %w( command control ) ) do |windowController|

  pageName = Time.now.strftime("%Y.%m.%d")
  windowController.document.createNewPageWithName(pageName)
  windowController.textView.insertText(pageName)

end
