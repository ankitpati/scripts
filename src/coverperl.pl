#!/usr/bin/env perl

use strict;
use warnings;

# User-serviceable Parts
my @criteria = qw(
    statement
    condition
);
@criteria = qw(default) unless @criteria;

my $cover_db = "$ENV{HOME}/cover_db/";
# End of User-serviceable Parts

{
    local $" = ',';
    $ENV{PERL5OPT} = "-MDevel::Cover=-coverage,@criteria";
}

system qw(perl), @ARGV;

delete $ENV{PERL5OPT};
exec qw(cover -outputdir), $cover_db, qw(-select), shift;
