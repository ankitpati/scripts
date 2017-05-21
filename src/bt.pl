#!/usr/bin/env perl

# Perl Test

use strict;
use warnings;

sub uniq { keys %{{ map { $_ => 1 } @_ }} }
use Cwd;
use File::Spec::Functions 'rel2abs';

my $noselect = grep /^--no-select$/, @ARGV;
my $maketest = grep /^--make-test$/, @ARGV;
@ARGV = grep !/^--(?:no-select|make-test)$/, @ARGV xor $maketest
    or die "Usage:\n\tbt <filename>... [--no-select] | <--make-test>\n";

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
$username or die "Unsupported working directory!\n";
$username =~ s|/||;

my $base = "/home/$username";
$_ = rel2abs $_ foreach @ARGV;
chdir $base;

system qw(find . -type d -name cover_db -exec rm -rf {} +);

$ENV{HARNESS_PERL_SWITCHES} =
    '-MDevel::Cover=-coverage,statement,branch,condition,subroutine,time';

if ($maketest) {
    system qw(make test);
    exec   qw(cover -ignore_re ^t/|.*\.t$);
}

my @moose_tests;
foreach (@ARGV) {
    $_ =~ m|^.*?/Acme/(.*)\.pm$| or next;
    my $test_dir = "$base/t/lib/TestsFor/Acme/$1/";
    push @moose_tests, $_ if -e "$test_dir/base.pm" || -e "$test_dir/legacy.pm";
}

s|^(.*/)?(.*)\.pm$|${\($1 // '')}t/$2.t| foreach @ARGV;

my @no_t_files = grep !-e ($_), @ARGV;

foreach (@no_t_files) {
    s|\.t$||, s|/t/|/|, s@^.*?/Acme/@::@, s|/|::|g;
    $_ = "Acme$_";
}

my %dedup;
@dedup{
    map {
        my $test = $_;
        $test =~ s|^(.*/)?(.*)\.pm$|${\($1 // '')}t/$2.t|;
        $test;
    } @moose_tests
} = ();
my @t_files = grep -e ($_) && !exists $dedup{$_}, @ARGV;

foreach (@moose_tests) {
    s|\.pm$||, s@^.*?/Acme/@::@g, s|/|::|g;
    $_ = "Acme$_";
}

my @prove = (qw(
    prove -v
          -I/opt/rhk-hinter/lib/perl5
          -I/opt/perl/lib/site_perl/5.12.1
          -I/opt/perl/lib/site_perl/5.12.1/noarch
          -I/opt/perl/lib/5.12.1
          -I/opt/perl/lib/noarch
    ),   "-I/home/$username/lib/perl5",
         "-I/home/$username/lib/perl5/noarch-linux"
);

system @prove, @t_files if @t_files;

system @prove, qw(t/test_classes.t ::), uniq(@no_t_files, @moose_tests)
    if @no_t_files || @moose_tests;

s|/t/|/|, s|^$base/||, s|\.t$|\.pm| foreach @ARGV;
system 'cover', ( $noselect ? qw(-ignore_re ^t/|.*\.t$)
            : ('-select_re', '^'.( join '|', map(quotemeta, @ARGV) ).'$') );
