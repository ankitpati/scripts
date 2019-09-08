#!/usr/bin/env perl

use strict;
use warnings;

my $me = (split m|/|, $0)[-1];

# This is a copy of my personal Geany config.
# See https://gitlab.com/ankitpati/geany-config
my %apc = (
    build => {
        c     => [qw(gcc -Wall -Wextra -Wpedantic -Wno-unused-result -g
                     -o %e %f -lm -lSDL_bgi -lSDL2)],

        cpp   => [qw(c++14 -Wall -Wextra -Wpedantic -Wno-unused-result -g
                     -o %e %f -lSDL_bgi -lSDL2)],

        go    => [qw(go build %f)],
        java  => [qw(javac -Xlint:all %f)],
        m     => [qw(chmod +x %f)],
        php   => [qw(php -l %f)],
        pl    => [[qw(perl -cw %f)], [qw(chmod +x %f)]],
        py    => [[qw(python3 -m py_compile %f)], [qw(chmod +x %f)]],
        sh    => [[qw(bash -n %f)], [qw(chmod +x %f)]],
        swift => [qw(swiftc %f)],
        tcl   => [qw(chmod +x %f)],
        vhdl  => [[qw(ghdl -a %f)], [qw(ghdl -e %f)]],
    },

    compile => {
        c    => [qw(gcc -Wall -Wextra -Wpedantic -Wno-unused-result -c %f)],
        cpp  => [qw(c++14 -Wall -Wextra -Wpedantic -Wno-unused-result -c %f)],
        go   => [qw(go build %f)],
        java => 'javac -Xlint:all -d . *.java', # Needs shell-escaping.
        xml  => [qw(xmllint --noout --dtdvalid %e.dtd %f)],
    },

    lint => {
        html => [qw(xmllint --noout %f)],
        xml => [qw(xmllint --noout --schema %e.xsd %f)],
    },

    tidy => {
        c    => [[qw(indent -kr %f)],
                 [qw(astyle --style=kr --indent=spaces=4 -p %f)],
                 [qw(rm %f.orig %f~)]],

        cpp  => [[qw(indent -kr %f)],
                 [qw(astyle --style=kr --indent=spaces=4 -p %f)],
                 [qw(rm %f.orig %f~)]],

        css  => [qw(csstidy %f %f)],
        go   => [qw(go fmt %f)],
        html => [qw(tidy -mci --indent-spaces 4 -w 76 -asxhtml %f)],
        java => [[qw(astyle --style=java --indent=spaces=4 -p %f)],
                 [qw(rm %f.orig)]],
        pl   => [qw(perltidy -utf8 -w -b -bext=/ -wn -otr -pt=2 -sbt=2 -bt=1
                    -bbt=0 -tso -nsfs -skp -sfp -trp)],
    },
);

# %f, $f: filenames with the extension
# %e, $e: filenames with the extension stripped

sub execute {
    my ($f, $e, @cmd) = @_;
    s/%(.)/$1 eq 'f' ? $f : $1 eq 'e' ? $e : $1/ge foreach @cmd;
    die "\n" if system @cmd;
}

@ARGV and @ARGV <= 2 or die "Usage:\n\t$me <filename> [action]\n";

my ($f, $action) = @ARGV;
-f $f and -r $f or die "Non-existent or unreadable file!\n";
$action //= 'build';

my ($e, $filetype) = $f =~ /^(.*)\.([^.]+)$/
    or die "Cannot determine filetype!\n";

my $cmd = $apc{$action}{$filetype};
defined $cmd or die "Unsupported filetype or action!\n";

if (not ref $cmd) {
    execute $f, $e, $cmd;
}
elsif (not ref ($cmd->[0])) {
    execute $f, $e, @$cmd;
}
else {
    execute $f, $e, @$_ foreach @$cmd;
}
