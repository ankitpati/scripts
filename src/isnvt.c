/* isnvt.c */
/* Check for Non-NVT Characters in Files */
#include <stdio.h>
#include <ctype.h>

#define NVTAND  (~(size_t)0u << 7)
#define CONTEXT 5

int isnvt(unsigned c)
{
    return !(c & NVTAND);
}

int main(int argc, char **argv)
{
    int     c;
    size_t  i;
    FILE   *fin;

    if (argc < 2) {
        fprintf(stderr, "Usage:\n\tnvt-check <filename>...\n");
        return 1;
    }

    for (++argv; *argv; ++argv) {
        fin = fopen(*argv, "rb");
        if (!fin) {
            fprintf(stderr, "I/O Error: Could not open %s!\n", *argv);
            continue;
        }

        while (isnvt(fgetc(fin)) && !feof(fin) && !ferror(fin));

        printf("%s is ", *argv);
        if (feof(fin)) {
            puts("NVT.");
        }
        else {
            printf("not NVT. Position: %ld, Context: ", ftell(fin));

            i = 0;
            while (i < CONTEXT && !feof(fin) && !ferror(fin))
                if (isnvt(c = fgetc(fin)) && !isspace(c)) {
                    putchar(c);
                    ++i;
                }

            putchar('\n');
        }

        fclose(fin);
    }

    return 0;
}
/* end of isnvt.c */
