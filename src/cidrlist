#!/usr/bin/env perl

use strict;
use warnings;

use Net::Netmask qw(cidrs2cidrs);

my $me = (split m|/|, $0)[-1];
my $usage = "Usage:\n\t$me <CIDR>...\n";

@ARGV or die $usage;

print "$_\n" foreach
    map { $_->enumerate } cidrs2cidrs
    map { eval { Net::Netmask->new2 ($_) } or die $usage } @ARGV;
