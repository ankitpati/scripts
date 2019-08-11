#!/usr/bin/env perl

use strict;
use warnings;

use String::ShellQuote qw(shell_quote);

exec 'shell-quote', @ARGV if @ARGV;

local $/;
print shell_quote (<STDIN>), "\n";
