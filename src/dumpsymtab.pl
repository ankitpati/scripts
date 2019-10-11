#!/usr/bin/env perl

use strict;
use warnings;

use DDP;

sub dumpvar {
    my $package = shift;

    no strict qw(refs);
    my %stash = %{ "${package}::" };
    use strict qw(refs);

    while (my ($var, $glob) = each %stash) {
        print "=== $var ===\n";
        p $$glob if defined $$glob;
        p @$glob if @$glob;
        p %$glob if %$glob;
        print "\n";
    }

    return;
}
