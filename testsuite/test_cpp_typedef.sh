#!/bin/bash

# test the collection of typedef names

cat <<EOF > test_typedef.cpp
#include <vector>
typedef vector<int> int_vector;
typedef char* char_array[5];    //array of char ptr
typedef int (*functionPtr)(int, int);  // with fxn pointer

EOF

input=$(srcml test_typedef.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="int_vector is a vector<int> typedef in C++ file: test_typedef.cpp at 2:21
char_array is a char* typedef in C++ file: test_typedef.cpp at 3:15
functionPtr is a int function in C++ file: test_typedef.cpp at 4:15"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_typedef failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_typedef passed!"
# Repeat tests

exit 0