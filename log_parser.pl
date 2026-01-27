#!/usr/bin/perl

use strict;
use warnings;

my %config;
my $config_file = 'parser.conf';

open(my $fh, '<', $config_file) or die "Could not open file '$config_file' $!";
while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/;
    next if $line =~ /^\s*#/;
    if ($line =~ /^(\w+)=(.*)$/) {
                $config{$1} = $2;
                $config{$1} =~ s/^\s+//;
    }
}
close($fh);

if ($config{'mode'} eq 'single_line') {
    my $args = join(' ', map { "-v $_=\"$config{$_}\"" } grep { $_ ne 'mode' } keys %config);
    my $file_to_parse = $ARGV[0] // die "Error: Please provide a file to parse as the first argument.";
    $args .= " $file_to_parse";
    system("perl parsers/single_line.awk $args");
} elsif ($config{'mode'} eq 'multi_line') {
    my $args = join(' ', map { "-v $_=\"$config{$_}\"" } grep { $_ ne 'mode' } keys %config);
    my $file_to_parse = $ARGV[0] // die "Error: Please provide a file to parse as the first argument.";
    $args .= " $file_to_parse";
    system("perl parsers/multi_line.awk $args");
} else {
    die "Error: mode '$config{mode}' is not recognized. Please use 'mode=single_line' or 'mode=multi_line'.\n";
}


