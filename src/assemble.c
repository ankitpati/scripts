/* assemble.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define COMPILER "tasm.exe "
#define LINKER   "tlink.exe "

int main(int argc, char **argv)
{
    size_t flen;
    char *s;

    if (argc != 2) {
        fprintf(stderr, "Usage:\n\tassemble <filename>\n");
        exit(1);
    }

    flen = strlen(argv[1]);

    /* compiler call */
    if (!(s = malloc(flen + strlen(COMPILER) + 1))) goto alocerr;
    strcpy(s, COMPILER);
    strcat(s, argv[1]);
    system(s);
    free(s);

    /* linker call */
    if (!(s = malloc(flen + strlen(LINKER) + 1))) goto alocerr;
    strcpy(s, LINKER);
    strcat(s, argv[1]);
    system(s);
    free(s);

    /* cleanup */
    if (!(s = malloc(flen + 5))) goto alocerr;
    strcpy(s, argv[1]);
    strcpy(s + flen, ".MAP");
    remove(s);
    strcpy(s + flen, ".OBJ");
    remove(s);
    strcpy(s + flen, ".TR");
    remove(s);
    free(s);
    remove("TDCONFIG.TD");

    return 0;

alocerr:
    fprintf(stderr, "assemble: Allocation Error!\n");
    return 12;
}

/* end of assemble.c */
