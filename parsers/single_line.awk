#!/usr/bin/awk -f

# Usage ./single_line.awk -v error_match_1="your_regex_here" -v error_match_2="other_regex_here" -v output_file="output.txt" input_file
# Support up to 4 regex patterns
# To enable case insensitive matching, pass ignore_case="yes" as a variable.
# To print to stdout, skip passing a output_file.
#
# Matches each line of $error_match_[NUM] and prints only if it has not already been printed once.
# Uses the last or second to last field as unique identifier to check if the line has already been printed.
#
# Making BEGIN a loop is for some reason way harder than i expected
# Cant pass array to awk, cant iterate the number in the variable
# Sticking to simple if statments here

BEGIN {
    if (!error_match_1) {
        error_match_1 = "^$";
    }
    if (!error_match_2) {
        error_match_2 = "^$";
    }
    if (!error_match_3) {
        error_match_3 = "^$";
    }
    if (!error_match_4) {
        error_match_4 = "^$";
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
    if ($0 ~ error_match_1 || $0 ~ error_match_2 || $0 ~ error_match_3 || $0 ~ error_match_4) {
        id = $0
        if (!line_check[$(NF ? NF-(control_character ? control_character : 1) : NF)]++) {
            line_check[id] = $0
            sorter[sort++] = id
        }
    }
}

END {
    for (i = 0; i < sort; i++) {
        print line_check[sorter[i]]
    }
}
