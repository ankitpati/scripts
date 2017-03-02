#!/usr/bin/env perl

# Perl Bad Tests

use strict;
use warnings;

use Cwd;

die "Usage:\n\tbb [string pattern]\n" if @ARGV > 1;

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
die "Unsupported working directory!\n" unless $username;
$username =~ s|/||;

chdir "/home/$username";

exec qw(egrep -Hn --), shift, 'BAD_TESTS.txt' if @ARGV;

exec qw(vim BAD_TESTS.txt);