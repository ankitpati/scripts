/* alleyes.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define OUTFILE_PREFIX "/tmp/alleyes."

int main(int argc, char **argv, char **envp)
{
    FILE *fout;
    size_t read_bytes;
    char input[BUFSIZ], outfile[255], time_as_str[20];

    sprintf(time_as_str, "%zu", time(NULL));

    strcpy(outfile, OUTFILE_PREFIX);
    strcat(outfile, time_as_str);

    if (!(fout = fopen(outfile, "w"))) {
        fprintf(stderr, "alleyes: cannot open outfile for writing!\n");
        exit(1);
    }

    fputs("** Arguments **\n", fout);
    while (*argv) fprintf(fout, "%s\n", *argv++);
    fputc('\n', fout);

    fputs("** Environment **\n", fout);
    while (*envp) fprintf(fout, "%s\n", *envp++);
    fputc('\n', fout);

    fputs("** Standard Input **\n", fout);
    while ((read_bytes = fread(input, sizeof(*input), BUFSIZ, stdin))) {
        if (ferror(stdin)) {
            fprintf(stderr, "alleyes: error while reading stdin!\n");
            exit(2);
        }

        fwrite(input, sizeof(*input), read_bytes, fout);

        if (ferror(fout)) {
            fprintf(stderr, "alleyes: error while writing stdout!\n");
            exit(3);
        }

        if (feof(stdin)) break;
    }

    fclose(fout);
    return 0;
}
/* end of alleyes.c */
