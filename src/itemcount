#!/usr/bin/env perl

use strict;
use warnings;

my $me = (split m{/}, $0)[-1];

die "Usage:\n\t$me <filename>" if @ARGV != 1;

my $filename = shift;
my %counts;

open my $fin, '<', $filename or die "$me: could not read $filename!\n";
chomp, ++$counts{$_} while <$fin>;
close $fin;

print "$counts{$_} $_\n" foreach sort keys %counts;
