#!/usr/bin/env perl

# Moose Test Opener

use strict;
use warnings;

use Cwd;
use File::Basename;
use File::Path;
use File::Spec::Functions 'rel2abs';

my $filename = shift;
die "Usage:\n\tbm <filename>.pm\n"
    if shift || !$filename || $filename !~ /\.pm$/;

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
$username or die "Unsupported working directory!\n";
$username =~ s|/||;

$filename =~ m|^(?:.*/Acme/)?(.*)\.pm$|;
my $test_dir = "/home/$username/t/lib/TestsFor/Acme/$1/";

my $filepath = rel2abs $filename;
-e $filepath or die "$filename does not exist.\n";

chdir $test_dir or die "Moose tests do not exist for $filename.\n";

my $test_file = -e 'base.pm' ? 'base.pm' : -e 'legacy.pm' ? 'legacy.pm' : '';

exec qw(vim -O), $test_file, $filepath if $test_file;

die "Moose tests for $filename are not at the expected location.\n";
