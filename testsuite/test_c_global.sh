#!/bin/bash

# test the collection of global variable names in c

cat <<EOF > test_global.c
int global_int=55;
bool global_bool;
float global_float;
char global_char, a, b;
EOF

input=$(srcml test_global.c --position)
output=$(echo "$input" | ./nameCollector )
expected="global_int is a int global in C file: test_global.c:1:5
global_bool is a bool global in C file: test_global.c:2:6
global_float is a float global in C file: test_global.c:3:7
global_char is a char global in C file: test_global.c:4:6
a is a char global in C file: test_global.c:4:19
b is a char global in C file: test_global.c:4:22"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_global failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cpp_c_global passed!"
# Repeat tests

exit 0
