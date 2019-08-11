#!/usr/bin/env perl

# Basic Find

use strict;
use warnings;

use Cwd;

my $me = (split m|/|, $0)[-1];

@ARGV or die "Usage:\n\t$me <filname glob>...\n";

my @name;
push @name, (m|/| ? '-ipath' : '-iname', "*$_*", '-o') foreach @ARGV;
pop (@name), unshift (@name, '('), push (@name, ')') if @name;

exec qw[find . -not (
                      -path */cover_db -prune -or
                      -path */.git     -prune -or
                      -path */tmp      -prune -or
                      -path */web/run  -prune
                    )
               ( -type f -or -type d )], @name;
