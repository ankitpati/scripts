#!/usr/bin/env perl

use strict;
use warnings;

sub uniq { keys %{{ map { $_ => 1 } @_ }} }
use IPC::Run 'run';

@ARGV or die "Usage:\n\tgit-count <username>...\n";

foreach my $user (@ARGV) {
    run [qw(git log --no-merges), "--author=$user", qw(--oneline --shortstat)],
        '>', \my $log;
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

    run [qw(git log --no-merges), "--author=$user",
         qw(--name-only --pretty=format:)], '>', \$log;

    $files = grep !/^$/m, uniq split "\n", $log;

    print <<"EOT";
$user
    Files      : $files
    Commits    : $commits
    Insertions : $insertions
    Deletions  : $deletions

EOT
}
