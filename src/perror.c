#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>

int main(int argc, char **argv)
{
    int i;
    char *n;

    /* (1 + floor(log(~0u))) == maximum digits in int,
     * + 1 for '\0'
     */
    if(!(n = malloc( sizeof(char) * (1 + floor(log(~0u)) + 1) )))
        return 12; /* perror(12) == cannot allocate memory */

    if (argc < 2) {
        fprintf(stderr, "Usage:\n\tperror <errno>...\n");
        return 1;
    }

    for (i = 1; i < argc; ++i) {
        sprintf(n, "%d", errno = atoi(argv[i]));
        perror(n);
    }

    return 0;
}
