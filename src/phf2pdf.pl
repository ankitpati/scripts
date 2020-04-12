#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use File::Temp qw(tmpnam);
use URI;
use LWP::Simple qw(get);
use PDF::Create;

use constant {
    # Download URL Format String
    DL_FMT => 'https://online.pubhtml5.com'.'%s/files/large/%u.jpg',

    # X Scale Factor (between [0.00, 1.00], determined experimentally)
    XSCALE => 0.83,
};

my $me    = (split m{/}, $0)[-1];
my $usage = "Usage:\n\t$me <https://pubhtml5.com/...> ...\n";

@ARGV or die $usage;

my %paths;

foreach my $link (@ARGV) {
    my $uri = URI->new ($link);

    die $usage unless $uri->scheme eq 'https'        and
                      $uri->host   eq 'pubhtml5.com' and
                      $uri->path   ne '';

    $paths{$link} = $uri->path;
}

foreach my $path (map { $paths{$_} } @ARGV) {
    my $pdfname  = $path;
    $pdfname     =~ s{\W}{}g;
    $pdfname    .= '.pdf';

    my $pdf  = PDF::Create->new (filename => $pdfname);
    my $root = $pdf->new_page (MediaBox => $pdf->get_page_size ('A2'));

    for (my $pgnum = 1; my $jpg = get sprintf DL_FMT, $path, $pgnum; ++$pgnum) {
        my $img_tmp_filename = tmpnam . '-phf2pdf.jpg';

        open my $img_tmp_fh, '>', $img_tmp_filename;
        binmode $img_tmp_fh;

        print $img_tmp_fh $jpg;
        $img_tmp_fh->close;

        my $image = $pdf->image ($img_tmp_filename);
        my $page  = $root->new_page;
        $page->image (
            xpos   => 0,
            ypos   => 0,
            xscale => XSCALE,
            image  => $image,
        );

        unlink $img_tmp_filename;
    }

    $pdf->close;
}
