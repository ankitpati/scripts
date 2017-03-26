#!/usr/bin/env perl

use strict;
use warnings;

use IPC::Run 'run';

die "Usage:\n\tgit-filter-author <username>...\n" unless @ARGV;

my $branch = `git rev-parse --abbrev-ref HEAD`;
chomp $branch;

my $root_commit = `git rev-list --max-parents=0 HEAD`;
chomp $root_commit;

my @hyphenated_users = map s/ /-/gr, @ARGV;
$" = '-';

my $new_branch = "commits-by-@hyphenated_users";
$branch = 'master' if $branch eq $new_branch;
system qw(git checkout), $branch;

system qw(git branch -D), $new_branch;
system qw(git checkout --orphan), $new_branch;

system qw(git reset);
system qw(git clean -fd);

system qw(git cherry-pick), $root_commit;

foreach my $user (@ARGV) {
    run [qw(git log), $branch, "--author=$user", '--format=%H'],
        '>', \my $commit_list;

    system qw(git cherry-pick), $_ foreach reverse split /\s/, $commit_list;
}
