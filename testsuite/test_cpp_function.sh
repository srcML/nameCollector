#!/bin/bash

# test the collection of global variable names in c++

cat <<EOF > test_function.cpp
int main(){
    return 0;
}

EOF

input=$(srcml test_function.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="main is a int function in C++ file: test_function.cpp at 1:5"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_function failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

# Repeat tests

exit 0