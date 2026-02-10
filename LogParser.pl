#!/usr/bin/perl

# LogParser.pl
# A script to analyze and parse log files with support for directories or single files.
# The parsing behavior can be configured using a configuration file.
# Utilizes external awk parsers for parsing logic.

use strict;
use warnings;
use Getopt::Long;
use lib 'lib';
use ConfigLoader;
use FileHandler;
use ParserExecutor;

# Main entry point
sub main {
    my ($file_to_parse, $config_file) = parse_arguments();

    # Load configuration file
    my %config = ConfigLoader::load_config($config_file);

    # Determine if the target is a directory or a file
    if (-d $file_to_parse) {
        process_directory($file_to_parse, \%config);
    } else {
        process_file($file_to_parse, \%config);
    }
}

# Parse command-line arguments
sub parse_arguments {
    my $config_file = 'parser.conf';
    my $file_to_parse;

    GetOptions(
        "file=s"   => \$file_to_parse,
        "config=s" => \$config_file
    ) or die("Error in command line arguments\n");

    die("Error: --file argument is required\n") unless $file_to_parse;

    return ($file_to_parse, $config_file);
}

# Process a directory of files
sub process_directory {
    my ($directory, $config) = @_;

    my @files = FileHandler::get_files_in_directory($directory);

    # Process each file in the directory
    foreach my $file (@files) {
        process_file($file, $config);
    }
}

# Process a single file
sub process_file {
    my ($file, $config) = @_;

    die("Error: File not found: $file\n") unless -f $file;

    my $mode = $config->{"mode"} // die("Error: 'mode' not defined in config file\n");

    ParserExecutor::execute_parser($mode, $config, $file);
}

# Run the main script
main();
