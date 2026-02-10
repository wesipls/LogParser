# ParserExecutor.pm
# Executes awk parsers for processing logs based on the specified mode ('single_line' or 'multi_line').
# Handles dynamic arguments based on the provided configuration and validates execution success.

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

    print "\n=== Start of file: $file_path ===\n";
    if ($mode eq 'single_line') {
        system("perl parsers/single_line.awk $args") == 0 or die "Failed to execute single_line parser on $file_path: $!\n";
    } elsif ($mode eq 'multi_line') {
        system("perl parsers/multi_line.awk $args");
    }
    print "=== End of file: $file_path ===\n";
}

1;

