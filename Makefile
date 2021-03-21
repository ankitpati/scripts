CC      = cc
CFLAGS  = -Wall -Wextra -Wpedantic -O3
OBJECTS = $(shell find . -type f -name '*.c' | sed 's/\.c$$//')

all: $(OBJECTS)

$(OBJECTS): %: %.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(OBJECTS)

install:
