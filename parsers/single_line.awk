#!/usr/bin/awk -f

# Usage ./single_line.awk -v err1="your_regex_here" -v err2="other_regex_here" -v output_file="output.txt" input_file
# Support up to 4 regex patterns
# To enable case insensitive matching, pass ignore_case="yes" as a variable.
# To print to stdout, skip passing a output_file.
#
# Matches each line of $err[NUM] and prints only if it has not already been printed once.
# Uses the last or second to last field as unique identifier to check if the line has already been printed.
#
# Making BEGIN a loop is for some reason way harder than i expected
# Cant pass array to awk, cant iterate the number in the variable
# Sticking to simple if statments here

BEGIN {
    if (!err1) {
        err1 = "^$";
    }
    if (!err2) {
        err2 = "^$";
    }
    if (!err3) {
        err3 = "^$";
    }
    if (!err4) {
        err4 = "^$";
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

{
    if ($0 ~ err1 || $0 ~ err2 || $0 ~ err3 || $0 ~ err4) {
        id = $0
        if (!a[$(NF ? NF-1 : NF)]++) {
            a[id] = $0
            b[sort++] = id
        }
    }
}

END {
    for (i = 0; i < sort; i++) {
        print a[b[i]]
    }
}
