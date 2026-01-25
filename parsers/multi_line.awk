#!/usr/bin/awk -f

# Usage: ./multi_line.awk -v start_match_1="START_PATTERN" -v end_match="END_PATTERN"  -v output_file="output.txt" input_file
# Also supports optional start_match_2 and start_match_3 patterns if you need more regex matches.
# To enable case insensitive matching, pass ignore_case="true" as a variable.
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
# This script ran as: ./multi_line.awk -v start_match_1="ERROR" -v end_match="===" logfile would print everything between the equal signs.
#
# If you have any other examples not covered by this script, please open an issue on GitHub.

BEGIN {
    flag = 0

    if ((!start_match_1) || (!end_match)) {
      exit 1
    }
    if (!start_match_2) {
      start_match_2 = "^$";
    }
    if (!start_match_3) {
      start_match_3 = "^$";
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

$0 ~ start_match_1 {
    flag = 1
}
$0 ~ start_match_2 {
    flag = 1
}
$0 ~ start_match_3 {
    flag = 1
}
$0 ~ end_match {
    flag = 0
}

flag && !line_check[$(NF ? NF-(control_character ? control_character : 1) : NF)]++ {
    sorter[++count] = $0
}

END {
    for (i = 1; i <= count; i++) {
        print sorter[i]
    }
}

