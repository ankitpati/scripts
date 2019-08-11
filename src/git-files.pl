#!/usr/bin/env perl

use strict;
use warnings;

my $me = (split m|/|, $0)[-1];

die <<"EOU" if @ARGV == 0 or @ARGV > 2;
Usage:
    $me <first-ref> [second-ref]
EOU

exec qw(git diff-tree --no-commit-id --name-only -r), @ARGV;
