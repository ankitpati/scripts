#!/usr/bin/env perl

use strict;
use warnings;

# User-serviceable Parts
my @criteria = qw(
    statement
    branch
    condition
    subroutine
);
@criteria = qw(default) unless @criteria;
# End of User-serviceable Parts

{
    local $" = ',';
    $ENV{HARNESS_PERL_SWITCHES} = "-MDevel::Cover=-coverage,@criteria";
}

system 'prove', @ARGV;
delete $ENV{HARNESS_PERL_SWITCHES};

system qw(cover -ignore_re .*\.t$);
