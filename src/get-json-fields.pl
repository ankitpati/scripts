#!/usr/bin/env perl

use strict;
use warnings;

use open qw(:std :utf8);
use Unicode::UTF8 qw(encode_utf8);

use JSON qw(decode_json);

@ARGV or die <<"EOM";
Usage:
    ${\(split m|/|, $0)[-1]} <fieldname>... < input.json > output.csv
EOM

local ( $, , $\ , $/ ) = ( ',' , "\n" , undef );

my $reclist = decode_json encode_utf8 <STDIN>;

foreach my $rec (@$reclist) {
    print map { $rec->{$_} // '' } @ARGV;
}
