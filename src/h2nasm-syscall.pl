#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use constant {
    SYSCALL_HEADER_FILE => '/usr/include/asm/unistd_64.h',
    H_DEFINE_LOOKS_LIKE => qr/^#\s*define\s+__NR_/,
};

my $me = (split m{/}, $0)[-1];

my @headers = @ARGV || (SYSCALL_HEADER_FILE);

foreach my $header (@headers) {
    my $outfile = $header;
    $outfile =~ s{/}{-}g;
    $outfile =~ s/^-//;

    open my $fin, '<', $header;
    open my $fout, '>', $outfile;

    while (<$fin>) {
        chomp;
        next unless /${\(H_DEFINE_LOOKS_LIKE)}\w+\b/;

        s/${(\H_DEFINE_LOOKS_LIKE)}/%define SYS_/;
        s/\s+/ /g;

        print $fout "$_\n";
    }

    close $fin;
}
