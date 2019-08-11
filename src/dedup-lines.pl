#!/usr/bin/env perl

use strict;
use warnings;

my $NAME = (split m|/|, $0)[-1];

my ($file_expand, $file_delete) = @ARGV;

die <<"EOU" if @ARGV != 2;
Usage:
    $NAME <file-to-expand> <file-to-remove>

    file-to-expand (filename)
    file-to-remove (filename)
        Remove the contents of file-to-remove from the contents of
        file-to-expand, alphabetically sort, and output the result.
EOU

my %h;

open my $fex, '<', $file_expand or die "$NAME: could not read $file_expand.\n";
undef @h{<$fex>};
close $fex;

open my $fdl, '<', $file_delete or die "$NAME: could not read $file_delete.\n";
delete @h{<$fdl>};
close $fdl;

my $deduped = join '', sort keys %h;
chomp $deduped;
print "$deduped\n";
