#!/usr/bin/awk -f

# Usage ./single_line.awk -v err_match="your_regex_here" input_file

# Matches each line of $err_match and prints only if it has not already been printed once.
# Uses the last or second to last field as unique identifier to check if the line has already been printed.

# a = array for storing lines matching unique identifiers
# b = array for storing order of unique identifiers

BEGIN {
    if (!(err_match != "")) {
        exit
    }
}

{
    if ($0 ~ err_match && !a[$(NF?NF-1:NF)]++) {
      a[$(NF?NF-1:NF)] = $0
      b[sort++] = $(NF?NF-1:NF)
    }
}

END {
    for (i = 0; i < sort; i++) {
        print a[b[i]]
    }
}
