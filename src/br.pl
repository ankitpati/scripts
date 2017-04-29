#!/usr/bin/env perl

# Repo Root

use strict;
use warnings;

use Cwd;

@ARGV or die "Usage:\n\tbr <command> [arguments]...\n";

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
$username or die "Unsupported working directory!\n";
$username =~ s|/||;

chdir "/home/$username";
exec @ARGV;
