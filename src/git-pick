#!/usr/bin/env perl

use strict;
use warnings;

use IPC::Run qw(run);

my $NAME = (split m|/|, $0)[-1];

my ($branch, $commits) = @ARGV;

die <<"EOU" if @ARGV != 2 || $commits !~ /^\d+$/;
Usage:
    $NAME <branch> <commits>

    branch (string)
        Git branch to pick the commits from

    commits (integer)
        +ve: Commits to `chery-pick` from `branch`
        0  : `cherry-pick` all commits from `branch`
EOU

grep m|^. (?:remotes/)?$branch$|, split /\n/, `git branch -a`
    or die "$branch: no such branch.\n";

run [qw(git log), $branch, '--format=%H'], '>', \my $commit_list;

my @commit_list;
foreach my $commit (split /\n/, $commit_list) {
    push @commit_list, $commit if $commit =~ /^[0-9a-f]+$/;
}

$commits ||= @commit_list;
$commits = @commit_list < $commits ? @commit_list : $commits
    or die "No commits to cherry-pick.\n";

my $shell = `which git-sh` || $ENV{SHELL} || `where cmd.exe` || 'sh';

foreach (reverse @commit_list[0 .. $commits-1]) {
    my @command = ( qw(git cherry-pick), $_ );
    if ((system @command) >> 8) {
        print STDERR <<"EOT";

FAILURE : `@command`
git-pick: Shelling out for you to inspect and correct the situation.
git-pick: You may have to reexecute the failed command in the shell.
git-pick: After solving the cherry-pick, exit the shell to continue.
EOT
        system $shell;
    }
}
