#!/usr/bin/env perl

use strict;
use warnings;

use IPC::Run 'run';

die "Usage:\n\tgit-pick <branch> [commits]\n" if !@ARGV || @ARGV > 2;

my $branch = shift;
die "$branch: no such branch.\n"
    unless grep m|^. (?:remotes/)?$branch$|, split /\n/, `git branch -a`;

my $commits = shift || 0; # 0 will cherry-pick all commits from target branch
die "$commits is not a positive integer.\n" unless $commits =~ /^\d+$/;

run [qw(git log), $branch, '--format=%H'], '>', \my $commit_list;

my @commit_list = split /\s/, $commit_list;

$commits ||= @commit_list;
$commits = @commit_list < $commits ? @commit_list : $commits;

die "No commits to cherry-pick.\n" unless $commits;

my $shell = `which git-sh` || $ENV{SHELL} || 'sh';

foreach (reverse @commit_list[0 .. $commits-1]) {
    if ((system qw(git cherry-pick), $_) >> 8) {
        print STDERR <<'EOT';
git-pick: Shelling out for you to inspect and correct the situation.
git-pick: After solving the cherry-pick, exit the shell to continue.
EOT
        system $shell;
    }
}
