#!/usr/bin/env perl

use strict;
use warnings;

# UTF8 for Source Code, File Handles, and Command-Line Arguments
use utf8;
use open qw(:std :utf8);
use Encode qw(decode);
@ARGV = map { decode 'UTF-8', $_ } @ARGV unless utf8::is_utf8 $ARGV[0];

use Net::IP qw(:PROC); # Really means qw(ip_inttobin ip_bintoip);
use Math::BigInt;

my $me = (split m|/|, $0)[-1];
@ARGV or die "Usage:\n\t$me <ip|integer>...\n";

foreach (@ARGV) {
    s/\s+//g; # Remove all whitespace.

    print "$_ → ";

    if (/^( (\d{0,3}) \. ){3} (?2)$ | [:.]+/x) {
        # IPv4                        # IPv6

        my $ip = Net::IP->new ($_);
        unless ($ip) {
            print 'Invalid';
            next;
        }

        print $ip->intip || 0;
    }
    elsif (/^\d+$/) {
           # Decimal (integer)

        my $int = Math::BigInt->new ($_);

        my $ip = (
            ip_bintoip ip_inttobin ($int, 4), 4 or
            ip_bintoip ip_inttobin ($int, 6), 6 or
            0 # Extensible for future IP versions. Hopefully.
        );

        unless ($ip) {
            print 'Invalid';
            next;
        }

        print $ip;
    }
    else {
        print 'Invalid';
    }
}
continue {
    print "\n";
}
