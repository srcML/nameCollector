#!/bin/bash

cat <<EOF > test_c_macro.c
#include <stdio.h>
#define MAX_SIZE 100
#define SQUARE(x) ((x) * (x))
#define STR "test"

EOF

input=$(srcml test_c_macro.c --position)
output=$(echo "$input" | ./nameCollector )
expected="MAX_SIZE is a macro in C file: test_c_macro.c:2:9
SQUARE is a macro in C file: test_c_macro.c:3:9
STR is a macro in C file: test_c_macro.c:4:9"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_macro output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0