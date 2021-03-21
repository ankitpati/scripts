CC     		= cc
CFLAGS 		= -Wall -Wextra -Wpedantic -O3
OBJECTS		= $(shell find src/ -type f -name '*.c' | sed 's/\.c$$//')
EXECUTABLES = $(shell find src/ -type f | grep -v '\.')

all: $(OBJECTS)

$(OBJECTS): %: %.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(OBJECTS)

install:
	cp $(EXECUTABLES) /usr/local/bin/
