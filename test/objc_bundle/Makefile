TARGETS = objc_test.bundle objc_proto.bundle
OBJS = objc_test.o objc_proto.o
CFLAGS = -fno-common -g -fobjc-exceptions -Wall

.SUFFIXES: .bundle
.o.bundle:
	cc -o $@ ${CFLAGS} -bundle -framework Foundation -framework AddressBook $<

all: ${TARGETS}

clean:
	rm -f ${TARGETS} ${OBJS}
