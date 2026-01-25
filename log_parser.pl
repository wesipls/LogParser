#!/usr/bin/perl

use strict;
use warnings;

my %config;
my $config_file = 'parser.conf';
if (!-e $config_file) {
    $config_file = 'example_parser.conf';
}

open(my $fh, '<', $config_file) or die "Could not open file '$config_file' $!";
while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/;
    next if $line =~ /^\s*#/;
    if ($line =~ /^(\w+)=(.*)$/) {
        $config{$1} = $2; # Store key-value pairs in the hash
    }
}
close($fh);

# Check mode and decide which script to run.
if ($config{'mode'} eq 'single_line') {
    my $args = join(' ', map { "-v $_=\"$config{$_}\"" } grep { $_ ne 'mode' } keys %config);
    system("perl parsers/single_line.awk $args");
} elsif ($config{'mode'} eq 'multi_line') {
    my $args = join(' ', map { "--$_=$config{$_}" } grep { $_ ne 'mode' } keys %config);
    system("perl parsers/multi_line.awk $args");
} else {
    die "Error: mode '$config{mode}' is not recognized. Please use 'mode=single_line' or 'mode=multi_line'.\n";
}


