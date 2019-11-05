#!/usr/bin/env perl

use strict;
use warnings;

use Net::Netmask;

my $me = (split m|/|, $0)[-1];
my $usage = "Usage:\n\t$me [-l] <parent-CIDR> <child-CIDR>...\n";

my $is_list = grep /^-l$/, @ARGV;
@ARGV = grep !/^-l$/, @ARGV;

@ARGV >= 2 or die $usage;

my ($parent, @children) = map {
    eval { Net::Netmask->new2 ($_) } or die $usage;
} @ARGV;

my @diff = $parent->cidrs2inverse (@children);

print "$_\n" foreach map { $is_list ? $_->enumerate : $_ } @diff;
