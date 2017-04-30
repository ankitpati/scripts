#!/usr/bin/env perl

# Basic Find

use strict;
use warnings;

use Cwd;

@ARGV or die "Usage:\n\tbf <filname glob>...\n";

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
$username or die "Unsupported working directory!\n";
$username =~ s|/||;

my @name;
push @name, (m|/| ? '-path' : '-name', "*$_*", '-o') foreach @ARGV;
pop (@name), unshift (@name, '('), push (@name, ')') if @name;

chdir "/home/$username";
system qw(find . -not ( -path */cover_db -prune -or -path */.git -prune )
                 ( -type f -or -type d )), @name;
