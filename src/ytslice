#!/usr/bin/env perl

use strict;
use warnings;
use integer;

use Time::Piece;

my $time_re = qr/^
#   optional
#   +------------------------------+
#   |   optional                   |
#   |   +--------------+           |
#   |   |              | mandatory |  mandatory
    (?: (?: (\d\d?) : )? (\d\d?) :)?  (\d\d?)
            # hour       # minute     # second
$/x;

my $me = (split m|/|, $0)[-1];

die "Usage:\n\t$me <youtube-url> <start-time> <end-time>\n" if @ARGV != 3;

my ($yt_url, %start, %end);
($yt_url, $start{time}, $end{time}) = @ARGV;

@start{qw(hr min sec)} = $start{time} =~ /$time_re/;
@end{qw(hr min sec)} = $end{time} =~ /$time_re/;

die "$me: time should be in 00:00:00 (hr:min:sec) format!\n"
    unless grep defined, @start{qw(hr min sec)}
       and grep defined, @end{qw(hr min sec)};

$_ //= 0 foreach @start{qw(hr min sec)}, @end{qw(hr min sec)};

$start{time} = sprintf '%02d:%02d:%02d', @start{qw(hr min sec)};
$end{time} = sprintf '%02d:%02d:%02d', @end{qw(hr min sec)};

my $diff = Time::Piece->strptime ('' . (
    Time::Piece->strptime ($end{time}, '%T') -
    Time::Piece->strptime ($start{time}, '%T')
), '%s')->strftime ('%T');

# Extract URLs for video and audio streams separately.
my ($video, $audio) = split '\n', `youtube-dl -g "$yt_url"`;

if ($video eq $audio) {
    exec 'ffmpeg',
        '-ss', $start{time}, '-i', $video,
        '-t', $diff,
        'filename.mkv';
}
else {
    exec 'ffmpeg',
        '-ss', $start{time}, '-i', $video,
        '-ss', $start{time}, '-i', $audio,
        qw(-map 0:v -map 1:a),
        '-t', $diff,
        qw(-c:v libx264 -c:a aac),
        'filename.mkv';
}
