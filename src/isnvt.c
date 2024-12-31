/* Check for Non-NVT Characters in Files */
#include <stdio.h>
#include <ctype.h>

#define NVTAND  (~(size_t)0u << 7)
#define CONTEXT 5

int isnvt(unsigned character)
{
    return !(character & NVTAND);
}

void examine(FILE *fin, char *filename)
{
    char    context[CONTEXT + 1];
    int     current_character;
    int     previous_character;
    long    non_nvt_position;
    size_t  context_counter;
    size_t  line_number;
    size_t  non_nvt_line_number;

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


    if (feof(fin)) {
        printf("%s is NVT.\n", filename);
        return;
    }

    non_nvt_line_number = line_number;
    non_nvt_position = fin == stdin ? 0 : ftell(fin);

    context_counter = 0;

    while (
        context_counter < CONTEXT &&
        !feof(fin) &&
        !ferror(fin)
    ) {
        current_character = fgetc(fin);
        if (
            isnvt(current_character) &&
            isprint(current_character) &&
            !isspace(current_character)
        ) {
            context[context_counter++] = current_character;
        }
    }

    context[context_counter] = '\0';

    printf("%s is not NVT. Position: %ld, Line: %zu, Context: %s\n",
           filename, non_nvt_position, non_nvt_line_number, context);
}

int main(int argc, char **argv)
{
    FILE *fin;

    if (argc < 2) {
        examine(stdin, "Standard Input (stdin, file descriptor (fd) 0)");
        return 0;
    }

    for (++argv; *argv; ++argv) {
        fin = fopen(*argv, "rb");
        if (!fin) {
            fprintf(stderr, "I/O Error: Could not open %s!\n", *argv);
            continue;
        }

        examine(fin, *argv);

        fclose(fin);
    }

    return 0;
}
