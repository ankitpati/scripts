/* wrapbcc.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define COMPILER "bcc32.exe "

int main(int argc, char **argv)
{
    int flen, t;
    char *s;

    if (argc != 2) {
        fprintf(stderr, "Usage:\n\twrapbcc <filename>\n");
        exit(1);
    }

    flen = strlen(argv[1]);
    if (!(s = malloc(flen + strlen(COMPILER) + 1))) {
        fprintf(stderr, "wrapbcc: Allocation Error!\n");
        exit(12);
    }

    strcpy(s, COMPILER);
    strcat(s, argv[1]);

    if (system(s)) exit(2);
    free(s);

    if (!(s = malloc(flen + 3))) {
        fprintf(stderr, "wrapbcc: Allocation Error!\n");
        exit(12);
    }

    strcpy(s, argv[1]);

    for (t = flen; t && s[t] != '.'; --t);

    strcpy(s + t + 1, "tds");
    remove(s);

    strcpy(s + t + 1, "obj");
    remove(s);

    return 0;
}
/* end of wrapbcc.c */
