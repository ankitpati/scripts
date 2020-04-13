#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use File::Temp;
use LWP::Simple qw(get);
use PDF::Create;
use Parallel::ForkManager;
use URI;

use constant {
    DL_FMT      => 'https://online.pubhtml5.com'.'%s/files/large/%u.jpg',
    XSCALE      => 0.84, # between [0.00, 1.00]
    PHF_THREADS => 128,
};

sub uniq { my %h; undef @h{@_}; keys %h }

my $me    = (split m{/}, $0)[-1];
my $usage = "Usage:\n\t$me <https://pubhtml5.com/...> ...\n";

@ARGV or die $usage;

@ARGV = uniq @ARGV;
@ARGV = sort @ARGV;

my %paths;

foreach my $link (@ARGV) {
    my $uri = URI->new ($link);

    die $usage unless $uri->scheme eq 'https'        and
                      $uri->host   eq 'pubhtml5.com' and
                      $uri->path   ne '';

    $paths{$link} = $uri->path;
}

my $pm = Parallel::ForkManager->new (PHF_THREADS);
warn "[$$] Processing ${\($#ARGV + 1)} PHF Flipbooks...\n";

foreach my $path (map { $paths{$_} } @ARGV) {
    next if $pm->start;
    warn "[$$] Processing PHF Flipbook $path\n";

    my $pdfname  = $path;
    $pdfname     =~ s{\W}{}g;
    $pdfname    .= '.pdf';

    my $pdf  = PDF::Create->new (filename => $pdfname);
    my $root = $pdf->new_page (MediaBox => $pdf->get_page_size ('A2'));

    for (my $pgnum = 1; my $jpg = get sprintf DL_FMT, $path, $pgnum; ++$pgnum) {
        my $tmpjpg = File::Temp->new (SUFFIX => '.jpg');

        print $tmpjpg $jpg;

        my $image = $pdf->image ("$tmpjpg");
        my $page  = $root->new_page;
        $page->image (
            xpos   => 0,
            ypos   => 0,
            xscale => XSCALE,
            image  => $image,
        );
    }

    $pdf->close;
    $pm->finish;
}
$pm->wait_all_children;
