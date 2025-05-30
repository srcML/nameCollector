#!/bin/bash

# test the collection of local variable names in c++
#### needs more test cases ####

cat <<EOF > test_local.cpp
int multiply(int a, int b){
    int return_value = a*b;
    return return_value;
}
EOF

input=$(srcml test_local.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="multiply is a int function in C++ file: test_local.cpp at 1:5
a is a int parameter in C++ file: test_local.cpp at 1:18
b is a int parameter in C++ file: test_local.cpp at 1:25
return_value is a int local in C++ file: test_local.cpp at 2:9"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_local failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

# Repeat tests

exit 0