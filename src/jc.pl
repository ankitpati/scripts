#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename;

die "Usage:\n\tjc <jenkins-command> [params]...\n" unless @ARGV;

exec 'java', '-jar', dirname (__FILE__).'/jenkins-cli.jar', '-noKeyAuth', @ARGV,
        '--username', 'your-username-here', '--password', 'your-password-here';
