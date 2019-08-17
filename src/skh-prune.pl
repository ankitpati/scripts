#!/usr/bin/env perl
# Prune SSH Known Hosts

use strict;
use warnings;

sub uniq { my %h; undef @h{@_}; keys %h }

# UTF8 for File Handles and Command Line Arguments
use open qw(:std :utf8);
use Encode qw(decode);
@ARGV = map { decode 'UTF-8', $_ } @ARGV unless utf8::is_utf8 $ARGV[0];

# get filenames as arguments, or fallback to sensible defaults
@ARGV or @ARGV = ("$ENV{HOME}/.ssh/known_hosts");

foreach my $skhfile (@ARGV) {
    open my $fin, '<', $skhfile
        or die "Could not open $skhfile for reading!\n";

    my %mappings;
    while (<$fin>) {
        my @record = split ' ';
        push @{ $mappings{join ' ', @record[1, 2]} }, # comments are lost
             split ',', $record[0];
    }

    close $skhfile;

    my @records = map { join ( ',', sort (&uniq (@{$mappings{$_}})) ) . " $_" }
                      sort keys %mappings;

    open my $fout, '>', $skhfile
        or die "Could not open $skhfile for writing!\n";

    local $" = "\n";
    print $fout "@records\n";

    close $fout;
}

__END__
