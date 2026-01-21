#!/usr/bin/awk -f

# Matches each line of $err_match and prints only if it has not already been printed once.
# Uses the last or second to last field as unique identifier to check if the line has already been printed.

BEGIN {
    if (!(err_match != "")) {
        exit
    }
}

{
    if ($0 ~ err_match && !a[$(NF?NF-1:NF)]++) {
      a[$(NF?NF-1:NF)] = $0
    }
}

END {
    for (i in a) {
        print a[i]
    }
}
