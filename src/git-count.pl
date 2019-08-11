#!/usr/bin/env perl

use strict;
use warnings;

use List::AllUtils qw(uniq);
use IPC::Run qw(run);

@ARGV or die "Usage:\n\tgit-count <username>...\n";

foreach my $user (@ARGV) {
    my $log;

    run [qw(git log --no-merges --oneline --shortstat), "--author=$user"],
        '>', \$log;

    open my $log_fd, '<', \$log;

    my ($files, $commits, $insertions, $deletions);

    while (<$log_fd>) {
        ++$commits, next if /^[a-z0-9]+ /i;

        my ($ins) = /(\d+) insertion/;
        my ($del) = /(\d+) deletion/;

        $insertions += $ins || 0, $deletions += $del || 0;
    }

    close $log_fd;

    $commits ||= 0, $insertions ||= 0, $deletions ||= 0;

    run [qw(git -c log.showSignature=false log --no-merges --name-only
            --pretty=), "--author=$user"], '>', \$log;

    $files = grep !/^$/, uniq split "\n", $log;

    print <<"EOT";
$user
    Files      : $files
    Commits    : $commits
    Insertions : $insertions
    Deletions  : $deletions

EOT
}
