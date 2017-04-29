#!/usr/bin/env perl

# Basic Search

use strict;
use warnings;

use Cwd;

@ARGV or die "Usage:\n\tbs <string pattern> [filname glob]...\n";

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
$username or die "Unsupported working directory!\n";
$username =~ s|/||;

my $search = shift;

my @name;
push @name, (m|/| ? '-path' : '-name', $_, '-o') foreach @ARGV;
pop (@name), unshift (@name, '('), push (@name, ')') if @name;

chdir "/home/$username";
system qw(find . -not ( -path */cover_db -prune -or -path */.git -prune )
                 -type f), @name, qw(-exec egrep -HnI --), $search, qw({} +);
