#!/usr/bin/env perl

# Basic Find

use strict;
use warnings;

use Cwd;

# User-Serviceable Parts
my @ignore_directories = qw(.git __pycache__ cover_db);
my @find_types = qw(d f);
# End of User-Serviceable Parts

my $me = (split m|/|, $0)[-1];

@ARGV or die "Usage:\n\t$me <filname glob>...\n";

my (@name, @path, @type);

push @name, (m|/| ? '-ipath' : '-iname', "*$_*", '-o') foreach @ARGV;
pop (@name), unshift (@name, '('), push (@name, ')') if @name;

push @path, '-path', "*/$_", qw(-prune -or) foreach @ignore_directories;
pop (@path), unshift (@path, qw[-not (]), push (@path, ')') if @path;

push @type, '-type', $_, qw(-or) foreach @find_types;
pop (@type), unshift (@type, '('), push (@type, ')') if @type;

exec qw(find .), @path, @type, @name;
