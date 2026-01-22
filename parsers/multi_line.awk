#!/usr/bin/awk -f

# Usage: ./multi_line.awk -v start="START_PATTERN" -v end="END_PATTERN" input_file
#
# Prints everything between lines matching START_PATTERN and END_PATTERN,
# Checking for duplicates based on the second to last field (or last field if only one field exists).

BEGIN {
    flag = 0

    if ((!start) || (!end)) {
        exit 1
    }
}

$0 ~ start {
    flag = 1
}
$0 ~ end {
    flag = 0
}

flag && !a[$(NF?NF-1:NF)]++ {
    b[++c] = $0
}

END {
    for (i = 1; i <= c; i++) {
        print b[i]
    }
}

