#!/usr/bin/env perl

# Basic Find

use strict;
use warnings;

use Cwd;

die "Usage:\n\tbf <filname glob>...\n" unless @ARGV;

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
die "Unsupported working directory!\n" unless $username;
$username =~ s|/||;

my @name;
push @name, ('-name', $_, '-o') foreach @ARGV;
pop (@name), unshift (@name, '('), push (@name, ')') if @name;

chdir "/home/$username";
system qw(find . -not ( -path */cover_db -prune ) ( -type f -or -type d )),
       @name;
