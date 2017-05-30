#!/usr/bin/env perl

# Perl Test Opener

use strict;
use warnings;

use Cwd;
use File::Basename;
use File::Path;
use File::Spec::Functions 'rel2abs';

my $filename = shift;
die "Usage:\n\tbm <filename>\n" if shift || !$filename;

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
$username or die "Unsupported working directory!\n";
$username =~ s|/||;

my $filepath = rel2abs $filename;
-e $filepath or die "$filename does not exist.\n";

my $test_file;

if ($filename =~ m|^(?:.*/Acme/)?(.*)\.pm$|) {
    my $test_dir = "/home/$username/t/lib/TestFor/Acme/$1/";

    $test_file = -e "$test_dir/base.pm"   ? 'base.pm'   :
                 -e "$test_dir/legacy.pm" ? 'legacy.pm' : '';

    chdir $test_dir if $test_file;
}
elsif ($filename =~ /\.t$/) {
    $test_file = $filepath;
    $filepath =~ s|/t/|/|;
    $filepath =~ s|\.t$|\.pm|;
}

$test_file or
    ($test_file = $filename) =~ s|^(.*/)?(.*)\.pm$|${\($1 // '')}t/$2.t|;
-e $test_file or die "Tests for $filename are not at the expected location.\n";

exec qw(vim -O), $test_file, $filepath;
