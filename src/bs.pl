#!/usr/bin/env perl

# Basic Search

use strict;
use warnings;

use Cwd;

my $me = (split m|/|, $0)[-1];

@ARGV or die "Usage:\n\t$me <string pattern> [filname glob]...\n";

my $gitroot;
$gitroot = eval { `git rev-parse --show-toplevel` };
chomp $gitroot;
die "$me: Unsupported working directory or `git` not on \$PATH!\n"
    if $@ or not $gitroot;

my $search = shift;

my @name;
push @name, (m|/| ? '-path' : '-name', "*$_*", '-o') foreach @ARGV;
pop (@name), unshift (@name, '('), push (@name, ')') if @name;

chdir $gitroot;
exec qw(find . -not (
                      -path */cover_db  -prune -or
                      -path */.git      -prune -or
                      -path */tmp       -prune -or
                      -path */web/run   -prune
                    )
               -type f), @name, qw(-exec egrep -HnI --), $search, qw({} +);
