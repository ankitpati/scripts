#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename;

@ARGV or die "Usage:\n\tjc <jenkins-command> [params]...\n";

exec 'java', '-jar', dirname (__FILE__).'/jenkins-cli.jar', '-noKeyAuth', @ARGV,
        '--username', 'your-username-here', '--password', 'your-password-here';
