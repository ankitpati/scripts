#!/usr/bin/env python3
"""Decode QR code using the ZXing library."""

from sys import stderr, argv
from zxing import BarCodeReader


def main():
    """The entry point."""

    if len(argv) != 2:
        print("Usage:\n\tdecode-qr.py <filename>", file=stderr)
        exit(1)

    filename = argv[1]

    decoded = BarCodeReader().decode(filename, try_harder=False)
    if decoded:
        print(decoded)


if __name__ == '__main__':
    main()
