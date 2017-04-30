#!/usr/bin/env perl

# Perl New Test

use strict;
use warnings;

use Cwd;
use File::Basename;
use File::Path;
use File::Spec::Functions 'abs2rel';

die "Usage:\n\tbn <filename>... [--force]\n"
    if !@ARGV || (grep (/^--force$/, @ARGV) && @ARGV <  2);

my $force = 1 if grep /^--force$/, @ARGV;
@ARGV = grep !/^--force$/, @ARGV;

my ($username) = cwd =~ qr{^/home/(.*?/|.*)};
$username or die "Unsupported working directory!\n";
$username =~ s|/||;

foreach (@ARGV) {
    s|^(.*/)?(.*)\.pm$|${\($1 // '')}t/$2.t|;
    print("$_ exists. Use --force to overwrite.\n"), next if -e $_ && !$force;

    eval { mkpath dirname $_ };
    warn("Could not create required directories\n"), next if $@;
    open my $test_file, '>', $_ or warn("Could not create $_\n"), next;

    my $inc_path = abs2rel "/home/$username/acme/conf/", dirname $_;
    s@^.*?/Acme/|^t/|\.t$@@g, s@/t/|/@::@g;

    print $test_file <<"EOF";
# Tests for Acme::$_.
# ----------------${\('-' x length)}-

use strict;
use warnings;

use File::Basename qw(dirname);
BEGIN { require( dirname(\$0) . '/$inc_path/include.pm' ); }

use Test::More tests => 1;
use Test::Exception;
use Test::MockModule;
use Test::MockObject;

my \$pkg;

BEGIN {
    \$pkg = 'Acme::$_';
    use_ok(\$pkg);
}
EOF

    close $test_file;
}
