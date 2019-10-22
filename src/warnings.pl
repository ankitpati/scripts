#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

my $me = (split m{/}, $0)[-1];

my ($src, $dest) = (shift, shift);
die "Usage:\n\t$me [source-file] [destination-file]\n" if @ARGV;

my ($fin, $fout);
open $fin, '<', $src if $src;
open $fout, '>', $dest if $dest;
$fin //= \*STDIN;
$fout //= \*STDOUT;

while (<$fin>) {
    next if /^\s+/
         or /^(?:not )?ok \d+ [-#] /
         or /: [\d.]+ wallclock secs \(/
         or /^\}$/;

    print $fout $_;
}

close $fin;
close $fout;
