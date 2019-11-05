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
    next if /^ok \d+ [-#] / .. /^}$/
         or / # TODO\b/
         or /^\s+ok \d+(?: [-#] |$)/
         or /: [\d.]+ wallclock secs \(/
         or /^\s*}$/
         or /^\s*\d+\.\.\d+$/
    ;
    s/ \{$// if /^\s*not ok \d+ [-#] /;
    print $fout $_;
}

close $fin;
close $fout;
