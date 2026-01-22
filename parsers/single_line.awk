#!/usr/bin/awk -f

# Usage ./single_line.awk -v err_match="your_regex_here" input_file

# Matches each line of $err_match and prints only if it has not already been printed once.
# Uses the last or second to last field as unique identifier to check if the line has already been printed.

# a = array for storing lines matching unique identifiers
# b = array for storing order of unique identifiers

BEGIN {
    if (!(err1 != "")) {
        err1 = "^$";
    }
    if (!(err2 != "")) {
        err2 = "^$";
    }
    if (!(err3 != "")) {
        err3 = "^$";
    }
    if (!(err4 != "")) {
        err4 = "^$";
    }
}

{
    if (($0 ~ err1 || $0 ~ err2 || $0 ~ err3 || $0 ~ err4) && !a[$(NF?NF-1:NF)]++) {
      a[$(NF?NF-1:NF)] = $0
      b[sort++] = $(NF?NF-1:NF)
    }
}

END {
    for (i = 0; i < sort; i++) {
        print a[b[i]]
    }
}
