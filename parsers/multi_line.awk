#!/usr/bin/awk -f

# Usage: ./multi_line.awk -v start="START_PATTERN" -v end="END_PATTERN"  -v output_file="output.txt" input_file
# Also supports optional start2 and start3 patterns if you need more regex matches.
# To enable case insensitive matching, pass ignore_case="yes" as a variable.
# To print to stdout, skip passing a output_file.
#
# Prints everything between lines matching START_PATTERN and END_PATTERN.
# Checking for duplicates based on the second to last field (or last field if only one field exists).
#
#
# Usually multi line errors tend to look something like follows:
#
# ==================================================
# [ERROR] 2024-01-01 12:00:00 Some error occurred
# on trace id 12345
# maybe everything has crashed
# ==================================================
#
# This script ran as: ./multi_line.awk -v start="ERROR" -v end="===" logfile would print everything between the equal signs.
#
# If you have any other examples not covered by this script, please open an issue on GitHub.

BEGIN {
    flag = 0

    if ((!start) || (!end)) {
      exit 1
    }
    if (!start2) {
      start2 = "^$";
    }
    if (!start3) {
      start3 = "^$";
    }
    if (ignore_case == "yes") {
      IGNORECASE = 1;
    }
    if (output_file) {
        output_stream = output_file
    } else {
        output_stream = "/dev/stdout"
    }
}

$0 ~ start {
    flag = 1
}
$0 ~ start2 {
    flag = 1
}
$0 ~ start3 {
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

