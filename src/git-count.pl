#!/usr/bin/env perl

use strict;
use warnings;

use IPC::Run 'run';

die "Usage:\n\tgit-count <username>...\n" unless @ARGV;

foreach my $user (@ARGV) {
    run [qw(git log), "--author=$user", qw(--oneline --shortstat)],
        '>', \my $log;
    open my $log_fd, '<', \$log;

    my ($commits, $insertions, $deletions);

    while (<$log_fd>) {
        ++$commits, next if /^[a-z0-9]+ /i;

        my ($ins) = /(\d+) insertion/;
        my ($del) = /(\d+) deletion/;

        $insertions += $ins || 0, $deletions += $del || 0;
    }

    close $log_fd;

    $commits ||= 0, $insertions ||= 0, $deletions ||= 0;
    print <<"EOT";
$user
    Commits    : $commits
    Insertions : $insertions
    Deletions  : $deletions

EOT
}
