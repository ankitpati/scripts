#!/usr/bin/env perl

use strict;
use warnings;

use IPC::Run 'run';

@ARGV or die "Usage:\n\tgit-filter-author <username>...\n";

my $branch = `git rev-parse --abbrev-ref HEAD`;
chomp $branch;

my $root_commit = `git rev-list --max-parents=0 HEAD`;
chomp $root_commit;

my @hyphenated_users = @ARGV;
s/ /-/g foreach @hyphenated_users;
$" = '-';

my $new_branch = "commits-by-@hyphenated_users";
$branch = 'master' if $branch eq $new_branch;
system qw(git checkout), $branch;

system qw(git branch -D), $new_branch;
system qw(git checkout --orphan), $new_branch;

system qw(git reset);
system qw(git clean -fd);

system qw(git cherry-pick), $root_commit;

my $shell = `which git-sh` || $ENV{SHELL} || 'sh';

foreach my $user (@ARGV) {
    run [qw(git log), $branch, "--author=$user", '--format=%H'],
        '>', \my $commit_list;

    foreach (reverse grep !/^$root_commit$/, split /\s/, $commit_list) {
        if ((system qw(git cherry-pick), $_) >> 8) {
            print STDERR <<'EOT';
git-filter-author: Shelling out for you to inspect and correct the situation.
git-filter-author: After solving the cherry-pick, exit the shell to continue.
EOT
            system $shell;
        }
    }
}
