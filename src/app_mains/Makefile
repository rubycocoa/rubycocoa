
CC = cc
CFLAGS = -I/usr/lib/ruby/1.6/powerpc-darwin6.0 -framework Foundation
LIBRUBY_A = /usr/lib/ruby/1.6/powerpc-darwin6.0/libruby.a
LIBRUBY_DYLIB = -lruby
TARGET = AppMain_Exec AppMain_LibrubyA AppMain_LibrubyDylib

all:	$(TARGET)

clean:
	-rm -f $(TARGET)

AppMain_Exec: main_using_exec.m
	$(CC) $(CFLAGS) -o $@ $<

AppMain_LibrubyA: main_using_libruby.m
	$(CC) $(CFLAGS) $(LIBRUBY_A) -o $@ $<
	strip -x $@

AppMain_LibrubyDylib: main_using_libruby.m
	$(CC) $(CFLAGS) $(LIBRUBY_DYLIB) -o $@ $<
