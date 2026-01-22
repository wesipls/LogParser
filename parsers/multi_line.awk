#!/usr/bin/awk -f
# This AWK script performs the same operation as the provided pipeline command.
# - It extracts the lines between the appearance of "rror" and "=====" string patterns.
# - It removes duplicate entries based on the last field of each line.

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
    print $0
}

