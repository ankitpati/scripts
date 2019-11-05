#!/usr/bin/env perl

# Repo Root

use strict;
use warnings;

use Cwd;

my $me = (split m|/|, $0)[-1];

@ARGV or die "Usage:\n\t$me <command> [arguments]...\n";

my $gitroot;
$gitroot = eval { `git rev-parse --show-toplevel 2>/dev/null` };
chomp $gitroot;
die "$me: Unsupported working directory or `git` not on \$PATH!\n"
    if $@ or not $gitroot;

chdir $gitroot;
exec @ARGV;
