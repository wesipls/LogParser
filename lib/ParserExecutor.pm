# Scriptr for executing the awk parsers, the awk scripts can be found in ../parsers/ directory.

package ParserExecutor;

use strict;
use warnings;

sub execute_parser {
    my ($mode, $config, $file_path) = @_;

    unless ($mode eq 'single_line' || $mode eq 'multi_line') {
        die "Error: mode '$mode' is not recognized. Please use 'single_line' or 'multi_line'.\n";
    }

    my $args = join(' ', map { "-v $_=\"$config->{$_}\"" } grep { $_ ne 'mode' } keys %{$config});
    $args .= " $file_path";

    print "\n=== Parsing file: $file_path ===\n";
    if ($mode eq 'single_line') {
        system("perl parsers/single_line.awk $args");
    } elsif ($mode eq 'multi_line') {
        system("perl parsers/multi_line.awk $args");
    }
}

1;

