#!/usr/bin/env perl

exec 'mysql', "--defaults-group-suffix=$ARGV[0]", @ARGV[1 .. $#ARGV] if @ARGV;
exec 'mysql';
