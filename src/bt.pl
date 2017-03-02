#!/usr/bin/env perl

# Perl Test

use strict;
use warnings;

use Cwd;

die "Usage:\n\tbt <filename>... [--no-select] | <--make-test>\n"
    if !@ARGV || (grep (/^--no-select$/, @ARGV) && @ARGV <  2)
              || (grep (/^--make-test$/, @ARGV) && @ARGV != 1);

my $noselect = 1 if grep /^--no-select$/, @ARGV;
@ARGV = grep !/^--no-select$/, @ARGV;

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
die "Unsupported working directory!\n" unless $username;
$username =~ s|/||;

$ENV{HARNESS_PERL_SWITCHES} = '-MDevel::Cover';
$ENV{PERL_TEST_HARNESS_DUMP_TAP} = '/home/report/';

if (grep /^--make-test$/, @ARGV) {
    chdir "/home/$username";
    system qw(find . -type d -name cover_db -exec rm -rf {} +);
    system qw(make test);
    system qw(cover -ignore_re .*\.t$);
}
else {
    s|^(.*/)?(.*)\.pm$|($1 // '') . "t/$2\.t"|e foreach @ARGV;

    system qw(find . -type d -name cover_db -exec rm -rf {} +);
    system 'prove', '-v',
                    '-I/opt/rhk-hinter/lib/perl5',
                    '-I/opt/perl/lib/site_perl/5.12.1',
                    '-I/opt/perl/lib/site_perl/5.12.1/noarch',
                    '-I/opt/perl/lib/5.12.1',
                    '-I/opt/perl/lib/noarch',
                    "-I/home/$username/lib/perl5",
                    "-I/home/$username/lib/perl5/noarch-linux",
                    @ARGV;

    s|^t/||, s|/t/|/|, s|\.t$|\.pm| foreach @ARGV;
    system 'cover', ( $noselect ? qw(-ignore_re .*\.t$)
                : ('-select_re', '^'.( join '|', map(quotemeta, @ARGV) ).'$') );
}
