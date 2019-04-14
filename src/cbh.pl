#!/usr/bin/env perl

# Compact Bash History

use strict;
use warnings;

sub uniq { my %h; undef @h{@_}; keys %h }

# UTF8 for File Handles and Command Line Arguments
use open qw(:std :utf8);
use Unicode::UTF8 qw(decode_utf8);
@ARGV = map { decode_utf8 $_ } @ARGV unless utf8::is_utf8 $ARGV[0];

# get filenames as arguments, or fallback to sensible defaults
@ARGV or @ARGV = ($ENV{HISTFILE} // "$ENV{HOME}/.bash_history");

# conversions applied in the order they appear
my @conversions = (
    [qr/^\s+|\s+$/s                        => ''                  ],
    [qr/\s+/                               => ' '                 ],
    [qr/^sudo /                            => ''                  ],
    [qr/^command /                         => ''                  ],
    [qr/^brew (?:upgrade|reinstall) /      => 'brew install '     ],
    [qr/^brew cask (?:upgrade|reinstall) / => 'brew cask install '],
    [qr/^cpan (?!install) /                => 'cpan install '     ],
    [qr/^cpanm (?!install) /               => 'cpanm '            ],
    [qr/^apt-get install /                 => 'apt install '      ],
    [qr/^yum install /                     => 'yum install '      ],
    [qr/^dnf install /                     => 'dnf install '      ],
);

# do not look for discards and prefixes if premature patterns match
my @prematures = (
    qr/--/,
    qr/[`!@\$^&*|=(){}<>[\]]/,
);

# discard these items without checking for prefixes
my @discards = (
    qr/^#/,
    qr/^(?:ck|md|sha).*?sum /,
    qr/^ack /,
    qr/^ag /,
    qr/^bf /,
    qr/^cd /,
    qr/^chmod /,
    qr/^cp /,
    qr/^diff /,
    qr/^grep /,
    qr/^history /,
    qr/^kill(?:all)? /,
    qr/^l(?:s|l|\.) /,
    qr/^locate /,
    qr/^man /,
    qr/^maria /,
    qr/^mkdir /,
    qr/^n?vim /,
    qr/^open /,
    qr/^perlcritic /,
    qr/^perldoc /,
    qr/^podchecker /,
    qr/^pt /,
    qr/^rg /,
    qr/^rm /,
    qr/^scp /,
    qr/^ssh /,
    qr/^ssh-copy-id /,
    qr/^tree /,
    qr/^view /,
    qr/^vimdiff /,
    qr/^wc /,
    qr/^which /,

    qr/^(?:git )?add /,
    qr/^(?:git )?blame /,
    qr/^(?:git )?branch /,
    qr/^(?:git )?checkout /,
    qr/^(?:git )?cherry-pick /,
    qr/^(?:git )?commit /,
    qr/^(?:git )?diff /,
    qr/^(?:git )?log /,
    qr/^(?:git )?pull /,
    qr/^(?:git )?push /,
    qr/^(?:git )?rebase /,
    qr/^(?:git )?reflog /,
    qr/^(?:git )?remote /,
    qr/^(?:git )?reset /,
    qr/^(?:git )?show /,
    qr/^(?:git )?stash /,
);

my @prefixes = (
# Keep package manager “info” and “install” commands in ARRAYrefs, as shown.
#   ['pkg-mgr info '  , 'pkg-mgr install '  ],

    ['brew info '     , 'brew install '     ],
    ['brew cask info ', 'brew cask install '],
    ['apt show '      , 'apt install '      ],
    ['dnf info '      , 'dnf install '      ],
    ['yum info '      , 'yum install '      ],
    ['snap info '     , 'snap install '     ],

    'cpan install ',
    'cpanm ',
);

foreach my $histfile (@ARGV) {
    open my $fin, '<', $histfile
        or die "Could not open $histfile for reading!\n";

    my (%prefix_history, @normal_history);

    LINE: while (<$fin>) {
        foreach my $conversion (@conversions) {
            s/$conversion->[0]/$conversion->[1]/g;
        }

        foreach my $premature (@prematures) {
            goto APPENDHIST if /$premature/;
        }

        foreach my $discard (@discards) {
            next LINE if /$discard/;
        }

        foreach my $prefix (map { ref $_ ? @$_ : $_ } @prefixes) {
            if (/^\Q$prefix\E/) {
                s/^\Q$prefix\E//;
                push @{$prefix_history{$prefix}}, split /\s+/;
                next LINE;
            }
        }

        APPENDHIST: push @normal_history, $_;
    }

    close $fin;

    @$_ = uniq @$_ foreach values %prefix_history;

    # Merge list for `brew info` and `brew install`, prioritising `install`.
    foreach my $info_install (grep ref, @prefixes) {
        my ($info, $install) = @prefix_history{@$info_install};
        @$info = grep { my $i = $_; !grep { $i eq $_ } @$install } @$info;
    }

    @$_ = sort @$_ foreach values %prefix_history;

    while (my ($prefix, $list) = each %prefix_history) {
        push @normal_history, "$prefix$_" foreach @$list;
    }

    @normal_history = sort (&uniq (@normal_history));

    open my $fout, '>', $histfile
        or die "Could not open $histfile for writing!\n";

    local $" = "\n";
    print $fout "@normal_history\n";

    close $fout;
}

__END__
