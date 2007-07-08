TARGET = objc_test.bundle
OBJS = objc_test.o
MORPH = morph
CFLAGS = -arch i386 -arch ppc -fobjc-exceptions

all: ${TARGET} ${MORPH}

${TARGET}: ${OBJS}
	cc -o $@ -arch i386 -arch ppc -fobjc-exceptions -bundle -framework Foundation -framework AddressBook ${OBJS}

${MORPH}:
	cc -o $@ $@.c

clean:
	rm -f ${TARGET} ${OBJS} ${MORPH}
