#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

# UTF8 for Source Code, File Handles, and Command-Line Arguments
use utf8;
use open qw(:std :utf8);
use Encode qw(decode);
@ARGV = map { decode 'UTF-8', $_ } @ARGV unless utf8::is_utf8 $ARGV[0];

my $me = (split m|/|, $0)[-1];
die "Usage:\n\t$me <client-suffix> [database]\n" unless @ARGV;
exec 'mysqldump', @ARGV if @ARGV > 2;
my ($suffix, $db) = @ARGV;

sub mycnf {
    my ($filenames, $cnf) = @_;
    $cnf //= {};

    $filenames = [$filenames] unless 'ARRAY' eq ref $filenames;

    foreach my $filename (@$filenames) {
        my $section;

        open my $fin, '<', $filename;
        while (<$fin>) {
            next if /^\s*#/ # comments
                 or /^\s*!/ # directives (we should handle these, but don’t)
                 or /^\s*$/ # blank lines
            ;

            if (/^\s*\[([^\]]+)\]\s*$/) {
                $section = $1;
                next;
            }

            my ($key, $val) = split '=';
            $key =~ s/^\s+|\s+$//g if $key; # Get rid of leading &
            $val =~ s/^\s+|\s+$//g if $val; # trailing whitespace.

            # Autovivify if it does not exist, overwrite if it does.
            $cnf->{$section}{$key} = $val;
        }
        close $fin;
    }

    return $cnf;
}

# Later configs override earlier ones. Most important config goes at end.
my @config_files = grep -r, ( # `-r`: Filter readable files from following.
    qw(
        /etc/my.cnf
        /etc/mysql/my.cnf
        /usr/local/etc/my.cnf
        /usr/local/etc/mysql/my.cnf
    ),
    "$ENV{HOME}/.my.cnf",
);

my %cnf = %{ mycnf \@config_files };

my %detail = %{ $cnf{"client$suffix"} }
    or die "$me: client suffix not found!\n";

my ($host, $port, $user, $password, $database)
    = @detail{qw(host port user password database)};

$host //= '127.0.0.1'; # not `localhost`, because that is a socket!
$port //= 3306;
$user //= 'root';
$password //= '';
$database = $db if defined $db;

exec 'mysqldump', '--lock-tables=false',
                  "-h$host", "-P$port", "-u$user", "-p$password", $database;
