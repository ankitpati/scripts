#!/usr/bin/env python
"""Convert webpage to PDF using the Sejda API."""

from sys import stderr, argv
from requests import request


def main():
    """The entry point."""

    if len(argv) != 3:
        print("Usage:\n\tgetpdf.py <link> <filename>", file=stderr)
        exit(1)

    link, filename = argv[1], argv[2]

    pdf = request('POST', 'https://api.sejda.com/v1/tasks',
                  headers={'Content-Type': 'application/json'},
                  json={'url': link, 'type': 'htmlToPdf'})

    with open(filename, 'wb') as fout:
        fout.write(pdf.content)


if __name__ == '__main__':
    main()
