TARGETDIR = ./html
INSTALL_TARGETDIR = ../doc
RUBY = ruby
SED = sed

TARGET = \
	$(TARGETDIR)/INDEX.en.html \
	$(TARGETDIR)/INDEX.ja.html \
	$(TARGETDIR)/CHANGES.en.html \
	$(TARGETDIR)/CHANGES.ja.html \
	$(TARGETDIR)/FAQ.en.html \
	$(TARGETDIR)/FAQ.ja.html \
	$(TARGETDIR)/GETTING.en.html \
	$(TARGETDIR)/GETTING.ja.html \
	$(TARGETDIR)/BUILD.en.html \
	$(TARGETDIR)/BUILD.ja.html \
	$(TARGETDIR)/LINKS.en.html \
	$(TARGETDIR)/LINKS.ja.html \
	$(TARGETDIR)/NEWS.en.html \
	$(TARGETDIR)/NEWS.ja.html \
	$(TARGETDIR)/PROGRAMMING.en.html \
	$(TARGETDIR)/PROGRAMMING.ja.html \
	$(TARGETDIR)/TRYSAMPLES.en.html \
	$(TARGETDIR)/TRYSAMPLES.ja.html \
	$(TARGETDIR)/REFERENCES.ja.html \
	$(TARGETDIR)/REFERENCES.en.html \
	$(TARGETDIR)/ChangeLog.html \
	$(TARGETDIR)/rubycocoasite.css

TEMPLATES = \
	sidebar-contents.en.xml sidebar-contents.ja.xml \
	sidebar-links.en.xml sidebar-links.ja.xml \
	sidebar-news.en.xml sidebar-news.ja.xml \
	site-menubar.en.xml site-menubar.ja.xml \
	page-template.html


all:	$(TARGETDIR) $(TARGET)

clean:
	-rm -f $(TARGET)

install:	$(TARGETDIR) $(TARGET)
	-cp -fp $(TARGET) $(INSTALL_TARGETDIR)

$(TARGET):	$(TEMPLATES)


$(TARGETDIR):
	-mkdir -p $(TARGETDIR)

$(TARGETDIR)/rubycocoasite.css:	rubycocoasite.css
	-cp -f $< $(TARGETDIR)/

$(TARGETDIR)/INDEX.en.html:	INDEX.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/INDEX.ja.html:	INDEX.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/CHANGES.en.html:	CHANGES.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/CHANGES.ja.html:	CHANGES.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/FAQ.en.html:	FAQ.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/FAQ.ja.html:	FAQ.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/GETTING.en.html:	GETTING.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/GETTING.ja.html:	GETTING.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/BUILD.en.html:	BUILD.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/BUILD.ja.html:	BUILD.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/LINKS.en.html:	LINKS.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/LINKS.ja.html:	LINKS.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/NEWS.en.html:	NEWS.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/NEWS.ja.html:	NEWS.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/PROGRAMMING.en.html:	PROGRAMMING.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/PROGRAMMING.ja.html:	PROGRAMMING.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/TRYSAMPLES.en.html:	TRYSAMPLES.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/TRYSAMPLES.ja.html:	TRYSAMPLES.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/REFERENCES.en.html:	REFERENCES.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/REFERENCES.ja.html:	REFERENCES.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/ChangeLog.html:		../ChangeLog
	echo "<html>" > $(TARGETDIR)/ChangeLog.html
	echo "<head><title>RubyCocoa - ChangeLog</title></head>" >> $(TARGETDIR)/ChangeLog.html
	echo "<body>"  >> $(TARGETDIR)/ChangeLog.html
	echo "<pre>"  >> $(TARGETDIR)/ChangeLog.html
#	$(SED) -e 's/</\&lt;/' -e 's/>/\&gt;/' $<  >> $(TARGETDIR)/ChangeLog.html
	$(SED) -e 's/<.*@.*>//' $<  >> $(TARGETDIR)/ChangeLog.html
	echo "</pre>" >> $(TARGETDIR)/ChangeLog.html
	echo "</body></html>" >> $(TARGETDIR)/ChangeLog.html

