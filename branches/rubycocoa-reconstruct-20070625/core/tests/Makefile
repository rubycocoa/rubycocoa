TARGET = objc_test.bundle
OBJS = objc_test.o

${TARGET}: ${OBJS}
	cc -o $@ -bundle -framework Foundation -framework AddressBook ${OBJS}

clean:
	rm -f ${TARGET} ${OBJS}
