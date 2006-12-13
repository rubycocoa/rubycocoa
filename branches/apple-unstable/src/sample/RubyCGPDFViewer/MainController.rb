#
#  MainController.rb
#  CGPDFViewer
#
#  Created by Laurent Sansonetti on 12/12/06.
#  Copyright (c) 2006 Apple Computer. All rights reserved.
#

class MainController < NSObject

  # These six methods pass the appropriate message to the current
  # (frontmost) PDFView.  They are called by the menu items and enable
  # keyboard shortcuts.
  def firstPage(sender)
    currentPDFView.setPageNumber(1)
  end
  
  def lastPage(sender)
    currentPDFView.setPageNumber(currentPDFView.pageCount)
  end

  def pageDown(sender)
    currentPDFView.incrementPageNumber(self)
  end
  
  def pageUp(sender)
    currentPDFView.decrementPageNumber(self)
  end

  def rotateLeft(sender)
    currentPDFView.rotateLeft(self)
  end

  def rotateRight(sender)
    currentPDFView.rotateRight(self)
  end

  # Retrieve the PDF View of the main window.
  def currentPDFView
    NSApp.mainWindow.windowControler.document.pdfView
  end

  # Disable inappropriate menu items.
  def validateMenuItem(item)
    action = item.action
    if action == 'firstPage:' or action == 'pageUp'
      currentPDFView != nil and currentPDFView.pageNumber != 1
    elsif action == 'lastPage:' or action == 'pageDown'
      currentPDFView != nil and currentPDFView.pageNumber != currentPDFView.pageCount
    elsif action == 'rotateLeft' or action == 'rotateRight'
      currentPDFView != nil
    else
      true
    end
  end

end
