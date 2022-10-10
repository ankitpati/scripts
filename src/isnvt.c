/* isnvt.c */
/* Check for Non-NVT Characters in Files */
#include <stdio.h>
#include <ctype.h>

#define NVTAND  (~(size_t)0u << 7)
#define CONTEXT 5

int isnvt(unsigned character)
{
    return !(character & NVTAND);
}

int main(int argc, char **argv)
{
    FILE   *fin;
    int     current_character;
    int     previous_character;
    size_t  context_counter;
    size_t  line_number;

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

        previous_character = '\0';
        line_number = 1;

        while (
            isnvt(current_character = fgetc(fin)) &&
            !feof(fin) &&
            !ferror(fin)
        ) {
            if (
                current_character == '\r' ||
                (previous_character != '\r' && current_character == '\n')
            ) {
                ++line_number;
            }

            previous_character = current_character;
        }

        printf("%s is ", *argv);

        if (feof(fin)) {
            puts("NVT.");
        } else {
            printf("not NVT. Position: %ld, Line: %zu, Context: ",
                   ftell(fin), line_number);

            context_counter = 0;

            while (
                context_counter < CONTEXT &&
                !feof(fin) &&
                !ferror(fin)
            ) {
                if (
                    isnvt(current_character = fgetc(fin)) &&
                    !isspace(current_character)
                ) {
                    putchar(current_character);
                    ++context_counter;
                }
            }

            putchar('\n');
        }

        fclose(fin);
    }

    return 0;
}
/* end of isnvt.c */
