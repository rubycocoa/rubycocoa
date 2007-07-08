TARGET = objc_test.bundle
OBJS = objc_test.o
CFLAGS = -arch ppc -arch i386 -fobjc-exceptions

${TARGET}: ${OBJS}
	cc -o $@ ${CFLAGS} -bundle -framework Foundation -framework AddressBook ${OBJS}

clean:
	rm -f ${TARGET} ${OBJS}
