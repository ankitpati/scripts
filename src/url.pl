#!/usr/bin/env perl

use strict;
use warnings;

# UTF8 for Source Code, File Handles, and Command-Line Arguments
use utf8;
use open qw(:std :utf8);
use Encode qw(decode);
@ARGV = map { decode 'UTF-8', $_ } @ARGV unless utf8::is_utf8 $ARGV[0];

use URL::Encode qw(url_encode_utf8 url_decode_utf8);

my $me = (split m|/|, $0)[-1];

my $decode = grep /^--decode$/, @ARGV;
my $encode = grep /^--encode$/, @ARGV;
my $chomp = grep /^--chomp$/, @ARGV;
@ARGV = grep !/^--(?:decode|encode|chomp)$/, @ARGV;
my $url = shift;

die "Usage:\n\t$me <--decode|--encode> [--chomp] [URL]\n"
    if @ARGV or not ($decode xor $encode);

unless (defined $url) {
    local $/;
    $url = <STDIN>;
}

chomp $url if $chomp;

print url_decode_utf8 $url if $decode;
print url_encode_utf8 $url if $encode;
print "\n";
