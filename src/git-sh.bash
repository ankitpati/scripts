#!/usr/bin/env bash
#
# A customized Bash environment suitable for Git work.
#
# Copyright © 2008 Ryan Tomayko <http://tomayko.com/>
# Copyright © 2008 Aristotle Pagaltzis <http://plasmasturm.org/>
# Copyright © 2023 Ankit Pati <https://ankitpati.in/>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
# Distributed under the GNU General Public License, version 2.0.

# ALIASES + COMPLETION =========================================================

# gitcomp <alias> <command>
#
# Complete command named <alias> like standard git command named
# <command>. <command> must be a valid git command with completion.
#
# Examples:
#   gitcomplete ci commit
#   gitcomplete c  checkout
function gitcomplete {
    local alias=$1
    local command=$2
    __git_complete "$alias" "_git_${command//-/_}"
}

# gitalias <alias>='<command> [<args>...]'
#
# Define a new shell alias (as with the alias builtin) named <alias>
# and enable command completion based on <command>. <command> must be
# a standard non-abbreviated git command name that has completion support.
#
# Examples:
#   gitalias c=checkout
#   gitalias ci='commit -v'
#   gitalias r='rebase --interactive HEAD~10'
function gitalias {
    local alias=${1%%=*}
    local command=${1#*=}
    local prog=${command##git }
    prog=${prog%% *}
    alias "$alias"="$command"
    gitcomplete "$alias" "$prog"
}

# create aliases and configure bash completion for most porcelain commands

# These are the standard set of aliases enabled by default in all
# git-sh sessions.

gitalias a='git add'
gitalias b='git branch'
gitalias c='git checkout'
gitalias d='git diff'
gitalias f='git fetch --prune'
gitalias k='git cherry-pick'
gitalias l='git log --pretty=oneline --abbrev-commit'
gitalias n='git commit --verbose --amend'
gitalias r='git remote'
gitalias s='git commit --dry-run --short'
gitalias t='git diff --cached'

# git add and the staging area
gitalias a='git add'
gitalias aa='git add --update'          # mnemonic: "add all"
gitalias stage='git add'
gitalias ap='git add --patch'
gitalias p='git diff --cached'          # mnemonic: "patch"
gitalias unstage='git reset HEAD'

# commits and history
gitalias ci='git commit --verbose'
gitalias ca='git commit --verbose --all'
gitalias amend='git commit --verbose --amend'
gitalias n='git commit --verbose --amend'
gitalias k='git cherry-pick'
gitalias re='git rebase --interactive'
gitalias pop='git reset --soft HEAD^'
gitalias peek='git log -p --max-count=1'

# git fetch
gitalias f='git fetch'
gitalias pm='git pull'          # mnemonic: pull merge
gitalias pr='git pull --rebase' # mnemonic: pull rebase

# git diff
gitalias d='git diff'
gitalias ds='git diff --stat'    # mnemonic: "diff stat"

# git reset
gitalias hard='git reset --hard'
gitalias soft='git reset --soft'
gitalias scrap='git checkout HEAD'

# git worktree
gitalias wt='git worktree'

_git_cmd_cfg=(
    'add            alias'
    'am             alias  stdcmpl'
    'annotate       alias'
    'apply          alias  stdcmpl'
    'archive        alias'
    'bisect         alias  stdcmpl'
    'blame          alias'
    'branch         alias  stdcmpl'
    'bundle                stdcmpl'
    'cat-file       alias'
    'checkout       alias  stdcmpl'
    'check-ignore   alias'
    'cherry-pick    alias  stdcmpl'
    'clean          alias'
    'clone          alias'
    'commit         alias  stdcmpl'
    'config         alias  stdcmpl'
    'describe       alias  stdcmpl'
    'diff           alias  stdcmpl'
    'difftool       alias'
    'fetch          alias  stdcmpl'
    'flow           alias'
    'format-patch   alias  stdcmpl'
    'fsck           alias'
    'gui            alias'
    'hash-object    alias'
    'init           alias'
    'instaweb       alias'
    'log            alias  logcmpl'
    'lost-found     alias'
    'ls-files       alias'
    'ls-remote      alias  stdcmpl'
    'ls-tree        alias  stdcmpl'
    'merge          alias  stdcmpl'
    'merge-base     alias  stdcmpl'
    'mergetool      alias'
    'patch-id       alias'
    'peek-remote    alias'
    'prune          alias'
    'pull           alias  stdcmpl'
    'push           alias  stdcmpl'
    'quiltimport    alias'
    'rebase         alias  stdcmpl'
    'reflog         alias'
    'remote         alias  stdcmpl'
    'repack         alias'
    'repo-config    alias'
    'request-pull   alias'
    'reset          alias  stdcmpl'
    'restore        alias'
    'rev-list       alias'
    'rev-parse      alias'
    'revert         alias'
    'send-email     alias'
    'send-pack      alias'
    'shortlog       alias  stdcmpl'
    'show           alias  stdcmpl'
    'show-branch    alias  logcmpl'
    'stash          alias  stdcmpl'
    'status         alias'
    'stripspace     alias'
    'submodule      alias  stdcmpl'
    'svn            alias  stdcmpl'
    'symbolic-ref   alias'
    'switch         alias'
    'tag            alias  stdcmpl'
    'tar-tree       alias'
    'var            alias'
    'whatchanged    alias  logcmpl'
    'worktree       alias  stdcmpl'
)

for cfg in "${_git_cmd_cfg[@]}" ; do
    read -r cmd opts <<< $cfg
    for opt in $opts ; do
        case $opt in
            alias)
                alias "$cmd"="git $cmd"
                ;;
            stdcmpl)
                __git_complete "$cmd" "_git_${cmd//-/_}"
                ;;
            logcmpl)
                __git_complete "$cmd" _git_log
                ;;
        esac
    done
done

# PROMPT =======================================================================

function gitsh_prompt {
    _git_headname
    _git_upstream_state
    printf '!'
    _git_repo_state
    _git_workdir
    _git_dirty
    _git_dirty_stash
}

PS1='$(gitsh_prompt)> '

# detect whether the tree is in a dirty state.
function _git_dirty {
    if ! git rev-parse --verify HEAD >/dev/null 2>&1
    then
        return 0
    fi
    local dirty_marker="$(git config gitsh.dirty 2>/dev/null || echo ' *')"

    if ! git diff --quiet 2>/dev/null
    then
        _git_apply_color "$dirty_marker" red
    elif ! git diff --staged --quiet 2>/dev/null
    then
        _git_apply_color "$dirty_marker" yellow
    else
        return 0
    fi
}

# detect whether any changesets are stashed
function _git_dirty_stash {
    if ! git rev-parse --verify refs/stash >/dev/null 2>&1
    then
        return 0
    fi
    local dirty_stash_marker="$(git config gitsh.dirty-stash 2>/dev/null || echo ' $')"
    _git_apply_color "$dirty_stash_marker" red
}

# detect the current branch; use 7-sha when not on branch
function _git_headname {
    local br=$(git symbolic-ref -q HEAD 2>/dev/null)
    if [[ -n $br ]]
    then
        br=${br#refs/heads/}
    else
        br=$(git rev-parse --short HEAD 2>/dev/null)
    fi
    _git_apply_color "$br" 'yellow reverse'
}

# detect the deviation from the upstream branch
function _git_upstream_state {
    local p

    # Find how many commits we are ahead/behind our upstream
    local count="$(git rev-list --count --left-right '@{upstream}'...HEAD 2>/dev/null)"
    count=${count//$'\t'/ }

    # calculate the result
    case "$count" in
        "") # no upstream
            p="" ;;
        "0 0") # equal to upstream
            p=" u=" ;;
        "0 "*) # ahead of upstream
            p=" u+${count#0 }" ;;
        *" 0") # behind upstream
            p=" u-${count% 0}" ;;
        *) # diverged from upstream
            p=" u+${count#* }-${count% *}" ;;
    esac

    _git_apply_color "$p" 'yellow bold'
}

# detect working directory relative to working tree root
function _git_workdir {
    subdir=$(git rev-parse --show-prefix 2>/dev/null)
    subdir=${subdir%/}
    workdir=${PWD%/"$subdir"}
    _git_apply_color "${workdir/*\/}${subdir:+/$subdir}" 'blue bold'
}

# detect if the repository is in a special state (rebase or merge)
function _git_repo_state {
    local state_marker
    local git_dir=$(git rev-parse --git-dir 2>/dev/null)
    if [[ -d "$git_dir/rebase-merge" || -d "$git_dir/rebase-apply" ]]
    then
        state_marker='(rebase)'
    elif [[ -f "$git_dir/MERGE_HEAD" ]]
    then
        state_marker='(merge)'
    elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]
    then
        state_marker='(cherry-pick)'
    else
        return 0
    fi
    _git_apply_color "$state_marker" red
}

declare -A gitsh_colors=(
    [blue bold]=$'\e[1;34m'
    [red]=$'\e[31m'
    [yellow bold]=$'\e[1;33m'
    [yellow reverse]=$'\e[7;33m'
    [yellow]=$'\e[33m'
)

# apply a color to the first argument
function _git_apply_color {
    local ansi_reset=$'\001\e[m\002'

    local output=$1
    local color=$2

    color="\001${gitsh_colors[$color]}\002"

    echo -ne "${color}${output}${ansi_reset}"
}

# CONFIG ==============================================================

# Source system-wide rc file.
if [[ -f /etc/gitshrc ]]
then
    source /etc/gitshrc
fi

# Source the user rc file.
if [[ -f $HOME/.gitshrc ]]
then
    source "$HOME/.gitshrc"
fi
