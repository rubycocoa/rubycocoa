TARGET = CHANGES.en.html \
	CHANGES.ja.html \
	FAQ.en.html \
	FAQ.ja.html \
	INDEX.en.html \
	INDEX.ja.html \
	INSTALL.en.html \
	INSTALL.ja.html \
	REFERENCES.en.html \
	REFERENCES.ja.html \
	USING.en.html \
	USING.ja.html \
	ChangeLog.html


all:	$(TARGET)

clean:
	-rm -f $(TARGET)


CHANGES.en.html: 	../doc/CHANGES.en
	ruby make_html.rb $<

CHANGES.ja.html:	../doc/CHANGES.ja
	ruby make_html.rb $<

FAQ.en.html:		../doc/FAQ.en
	ruby make_html.rb $<

FAQ.ja.html:		../doc/FAQ.ja
	ruby make_html.rb $<

INDEX.en.html:		../doc/INDEX.en
	ruby make_html.rb $<

INDEX.ja.html:		../doc/INDEX.ja
	ruby make_html.rb $<

INSTALL.en.html:	../doc/INSTALL.en
	ruby make_html.rb $<

INSTALL.ja.html:	../doc/INSTALL.ja
	ruby make_html.rb $<

REFERENCES.en.html:	../doc/REFERENCES.en
	ruby make_html.rb $<

REFERENCES.ja.html:	../doc/REFERENCES.ja
	ruby make_html.rb $<

USING.en.html:		../doc/USING.en
	ruby make_html.rb $<

USING.ja.html:		../doc/USING.ja
	ruby make_html.rb $<

ChangeLog.html:		../ChangeLog
	echo "<html>" > ChangeLog.html
	echo "<head><title>RubyCocoa - ChangeLog</title></head>" >> ChangeLog.html
	echo "<body>"  >> ChangeLog.html
	echo "<pre>"  >> ChangeLog.html
#	sed -e 's/</\&lt;/' -e 's/>/\&gt;/' $<  >> ChangeLog.html
	sed -e 's/<.*@.*>//' $<  >> ChangeLog.html
	echo "</pre>" >> ChangeLog.html
	echo "</body></html>" >> ChangeLog.html

