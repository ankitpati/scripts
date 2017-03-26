#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main(int argc, char **argv)
{
    int i;

    if (argc < 2) {
        fprintf(stderr, "Usage:\n\tperror <errno>...\n");
        return 1;
    }

    for (i = 1; i < argc; ++i) {
        fprintf(stderr, "%d: ", errno = atoi(argv[i]));
        perror("");
    }

    return 0;
}
