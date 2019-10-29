#!/usr/bin/env perl

use strict;
use warnings;

die "Usage:\n\tpt <filename>... [--no-select]\n"
    if !@ARGV || (grep (/^--no-select$/, @ARGV) && @ARGV <  2);

my $noselect = 1 if grep /^--no-select$/, @ARGV;
@ARGV = grep !/^--no-select$/, @ARGV;

$ENV{HARNESS_PERL_SWITCHES} = '-MDevel::Cover';

s|^(.*/)?(.*)\.pm$|${\($1 // '')}t/$2.t| foreach @ARGV;

system qw(find . -type d -name cover_db -exec rm -rf {} +);
system qw(prove -v), @ARGV;

s|^t/||, s|/t/|/|, s|\.t$|\.pm| foreach @ARGV;
system 'cover', ( $noselect ? qw(-ignore_re .*\.t$)
            : ('-select_re', '^'.( join '|', map(quotemeta, @ARGV) ).'$') );
