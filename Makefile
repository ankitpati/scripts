CC      = cc
CFLAGS  = -Wall -Wextra -Wpedantic -O3
OBJECTS = src/alleyes src/isnvt src/perror

all: $(OBJECTS)

$(OBJECTS): %: %.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	-find . -type f -name '*.c' | sed -E 's/\.c$$//' | xargs rm
