TARGETDIR = ./html
RUBYCOCOA_DIR = ../src
CHANGELOG_SRC = $(RUBYCOCOA_DIR)/Changelog
INSTALL_TARGETDIR = $(RUBYCOCOA_DIR)/doc

RUBY = ruby
SED = sed

TARGET = \
	$(TARGETDIR)/index.en.html \
	$(TARGETDIR)/index.ja.html \
	$(TARGETDIR)/changes.en.html \
	$(TARGETDIR)/changes.ja.html \
	$(TARGETDIR)/faq.en.html \
	$(TARGETDIR)/faq.ja.html \
	$(TARGETDIR)/getting.en.html \
	$(TARGETDIR)/getting.ja.html \
	$(TARGETDIR)/build.en.html \
	$(TARGETDIR)/build.ja.html \
	$(TARGETDIR)/links.en.html \
	$(TARGETDIR)/links.ja.html \
	$(TARGETDIR)/programming.en.html \
	$(TARGETDIR)/programming.ja.html \
	$(TARGETDIR)/trysamples.en.html \
	$(TARGETDIR)/trysamples.ja.html \
	$(TARGETDIR)/references.ja.html \
	$(TARGETDIR)/references.en.html \
	$(TARGETDIR)/changelog.html \
	$(TARGETDIR)/rubycocoasite.css

# 	$(TARGETDIR)/news.en.html \
# 	$(TARGETDIR)/news.ja.html \


TEMPLATES = \
	sidebar-contents.en.xml sidebar-contents.ja.xml \
	sidebar-links.en.xml sidebar-links.ja.xml \
	site-menubar.en.xml site-menubar.ja.xml \
	page-template.html

# 	sidebar-news.en.xml sidebar-news.ja.xml \


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

$(TARGETDIR)/index.en.html:	INDEX.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/index.ja.html:	INDEX.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/changes.en.html:	CHANGES.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/changes.ja.html:	CHANGES.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/faq.en.html:	FAQ.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/faq.ja.html:	FAQ.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/getting.en.html:	GETTING.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/getting.ja.html:	GETTING.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/build.en.html:	BUILD.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/build.ja.html:	BUILD.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/links.en.html:	LINKS.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/links.ja.html:	LINKS.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

# $(TARGETDIR)/news.en.html:	NEWS.en
# 	$(RUBY) make_html.rb $< $(TARGETDIR)

# $(TARGETDIR)/news.ja.html:	NEWS.ja
# 	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/programming.en.html:	PROGRAMMING.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/programming.ja.html:	PROGRAMMING.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/trysamples.en.html:	TRYSAMPLES.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/trysamples.ja.html:	TRYSAMPLES.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/references.en.html:	REFERENCES.en
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/references.ja.html:	REFERENCES.ja
	$(RUBY) make_html.rb $< $(TARGETDIR)

$(TARGETDIR)/changelog.html:		$(CHANGELOG_SRC)
	echo "<html>" > $(TARGETDIR)/changelog.html
	echo "<head><title>RubyCocoa - ChangeLog</title></head>" >> $(TARGETDIR)/changelog.html
	echo "<body>"  >> $(TARGETDIR)/changelog.html
	echo "<pre>"  >> $(TARGETDIR)/changelog.html
#	$(SED) -e 's/</\&lt;/' -e 's/>/\&gt;/' $<  >> $(TARGETDIR)/changelog.html
	$(SED) -e 's/<.*@.*>//' $<  >> $(TARGETDIR)/changelog.html
	echo "</pre>" >> $(TARGETDIR)/changelog.html
	echo "</body></html>" >> $(TARGETDIR)/changelog.html

